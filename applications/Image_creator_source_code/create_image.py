'''
Create images of result comparisions between serial and parallel solver
'''

import matplotlib.pyplot as plt
import numpy as np

RES_PATH = '../result/'
IMAGE_PATH = '../image/'
FILE_TYPE = ['parallel', 'serial']
PTG = 0.15
MAX_SAMPLES = 20

nbr_test = 1000
time_colors = ['-b','-g','-r','-c','-k','-m','-y']
marker_symbols = ['^', '*', 's', 'd', 'v','+']

def read_data(file):
    with open(file, "r") as data_file:
        result = []
        test_data = eval(data_file.read())
        tests = test_data.get("test_result")
        test_cases = tests["test_cases"]
        for test_case in test_cases :
            for test_result in test_case:
                result.append(test_result)
        data_file.close()
        return result
    

def fetch_result_time(r, c, i, over_flow, max_tests):
    p_file = FILE_TYPE[0]+'_'+str(r)+'_'+str(c)+'_'+str(i)+'_'+str(nbr_test)+'.txt'
    s_file = FILE_TYPE[1]+'_'+str(r)+'_'+str(c)+'_'+str(i)+'_'+str(nbr_test)+'.txt'
    p_res = read_data(RES_PATH+p_file)
    s_res = read_data(RES_PATH+s_file)
    test_len = 0
    if len(p_res) == len(s_res):
        test_len = len(p_res)
    else:
        print("Error:Unequal number of test cases")
    
    soft = []
    serial = []
    parallel = []
    
    test_count = 0
    for i in range(test_len):
        
        if (p_res[i]["overflow"] != over_flow or s_res[i]["overflow"] != over_flow):
            continue
        
        if (p_res[i]["soft"] < s_res[i]["soft"]):
            soft.append(p_res[i]["soft"])
        else:
            soft.append(s_res[i]["soft"])
        serial.append(s_res[i]["hard"])
        parallel.append(p_res[i]["hard"])
        test_count +=1
        if (max_tests == test_count):
            break
    
    return soft, serial, parallel


def normalize(soft, serial, parallel):
    mean_soft = np.mean(soft)
    mean_serial = np.mean(serial)
    mean_parallel = np.mean(parallel)
    
    n_soft = []
    n_serial = []
    n_parallel = []
    count = 0
    for i in range(len(soft)):
        if (soft[i] < (mean_soft + (mean_soft * PTG)) and soft[i] > (mean_soft - (mean_soft * PTG)) and
            serial[i] < (mean_serial + (mean_serial * PTG)) and serial[i] > (mean_serial - (mean_serial * PTG)) and
            parallel[i] < (mean_parallel + (mean_parallel * PTG)) and parallel[i] > (mean_parallel - (mean_parallel * PTG))):
            n_soft.append(soft[i])
            n_serial.append(serial[i])
            n_parallel.append(parallel[i])
            count+=1
            if (count >= MAX_SAMPLES):
                break
            
    return len(n_soft), n_soft, n_serial, n_parallel

def find_percentage(base, new):
    
    percentage_new = []
    for i in range(len(base)):
        percentage_new.append(int((abs(new[i]-base[i])/new[i])*100))
    
    return percentage_new

def compare_solver():
    row_arr = [3, 4, 5, 6, 7]
    col_arr = [3, 4, 5, 6, 7]
    int_range = [ 5, 10, 15, 20, 30, 50]

    for r in row_arr:
        for c in col_arr:
            for i in int_range:
                soft, serial, parallel = fetch_result_time(r, c, i, over_flow="NO", max_tests=1000)
                test_len, sof, ser, par = normalize(soft, serial, parallel)
                test_len_arr = range(test_len)
                plt.plot(test_len_arr, sof, '-g', marker='d')  # solid green
                plt.plot(test_len_arr, ser, '-c', marker='s') # dashed cyan
                plt.plot(test_len_arr, par, '-b', marker='x') # dashdot black
                plt.xlabel('number of random martix input')
                plt.ylabel('micro seconds')
                plt.title('row_len = ' +str(r)+' col_len = '+str(c)+' int_range = '+str(i))
                plt.legend(('software', 'serial', 'parallel'), loc='center right', shadow=True)
                plt.savefig(IMAGE_PATH + str(r)+'_'+str(c)+'_'+str(i)+'_'+str(nbr_test)+'.png')
                plt.close()
     
    for r in row_arr:
        for c in col_arr:
            for i in int_range:
                soft, serial, parallel = fetch_result_time(r, c, i, over_flow="NO", max_tests=1000)
                test_len, sof, ser, par = normalize(soft, serial, parallel)
                test_len_arr = range(test_len)
                percentage_ser = find_percentage(sof, ser)
                percentage_par = find_percentage(sof, par)
                percentage_par_ser = find_percentage(ser, par)
                plt.plot(test_len_arr, percentage_par, '-y', marker='d') # solid yellow
                plt.plot(test_len_arr, percentage_ser, '-r', marker='s')  # solid red
                plt.plot(test_len_arr, percentage_par_ser, '-m', marker='x') # solid maganta
                plt.xlabel('number of random martix input')
                plt.ylabel('% increase in speed')
                plt.title('row_len = ' +str(r)+' col_len = '+str(c)+' int_range = '+str(i))
                plt.legend(('%parallel wrt software', '%serial wrt software ', '%parallel wrt serial'), loc='center right', shadow=True)
                plt.savefig(IMAGE_PATH + str(r)+'_'+str(c)+'_'+str(i)+'_'+str(nbr_test)+'_percentage.png')
                plt.close()
                

def compare_row():
    row_arr = [7,6,5,4,3]
    col_arr = [7]
    int_range = [10]
    legend = []
    for r in row_arr:
        for c in col_arr:
            for i in int_range:
                soft, serial, parallel = fetch_result_time(r, c, i, over_flow="NO", max_tests=100)
                test_len, sof, ser, par = normalize(soft, serial, parallel)
                test_len_arr = range(test_len)
                w_label= 'r='+str(r)
                legend.append(w_label)
                plt.subplot(221)
                plt.plot(test_len_arr, sof, time_colors[row_arr.index(r)], label=w_label, marker=marker_symbols[row_arr.index(r)])  # solid green
                plt.title('software')
                plt.subplot(222)
                plt.plot(test_len_arr, ser, time_colors[row_arr.index(r)], label=w_label, marker=marker_symbols[row_arr.index(r)])  # solid green
                plt.title('serial')
                plt.subplot(223)
                plt.plot(test_len_arr, par, time_colors[row_arr.index(r)], label=w_label, marker=marker_symbols[row_arr.index(r)])  # solid green
                plt.title('parallel')

    plt.subplots_adjust(top=0.95, bottom=0.06, left=0.09, right=0.95, hspace=0.25,
                    wspace=0.25)
    plt.legend(legend,loc=(1.5, 0.1))
    plt.savefig(IMAGE_PATH + 'row_'+str(c)+'_'+str(i)+'.png')
    plt.close()
    
    for r in row_arr:
        for c in col_arr:
            for i in int_range:
                soft, serial, parallel = fetch_result_time(r, c, i, over_flow="NO", max_tests=100)
                test_len, sof, ser, par = normalize(soft, serial, parallel)
                percentage_ser = find_percentage(sof, ser)
                percentage_par = find_percentage(sof, par)
                percentage_par_ser = find_percentage(ser, par)
                test_len_arr = range(test_len)
                w_label= 'r='+str(r)
                legend.append(w_label)
                plt.subplot(221)
                plt.plot(test_len_arr, percentage_ser, time_colors[row_arr.index(r)], label=w_label, marker=marker_symbols[row_arr.index(r)])  # solid green
                plt.title('% of serial wrt software')
                plt.subplot(222)
                plt.plot(test_len_arr, percentage_par, time_colors[row_arr.index(r)], label=w_label, marker=marker_symbols[row_arr.index(r)])  # solid green
                plt.title('% of parallel wrt software')
                plt.subplot(223)
                plt.plot(test_len_arr, percentage_par_ser, time_colors[row_arr.index(r)], label=w_label, marker=marker_symbols[row_arr.index(r)])  # solid green
                plt.title('% of parallel wrt serial')

    plt.subplots_adjust(top=0.95, bottom=0.06, left=0.09, right=0.95, hspace=0.25,
                    wspace=0.25)
    plt.legend(legend,loc=(1.5, 0.1))
    plt.savefig(IMAGE_PATH + 'row_'+str(c)+'_'+str(i)+'percentage.png')
    plt.close()
    

def compare_col():
    row_arr = [7]
    col_arr = [7,6,5,4,3]
    int_range = [5]
    legend = []
    for r in row_arr:
        for c in col_arr:
            for i in int_range:
                soft, serial, parallel = fetch_result_time(r, c, i, over_flow="NO", max_tests=1000)
                test_len, sof, ser, par = normalize(soft, serial, parallel)
                test_len_arr = range(test_len)
                w_label= 'c='+str(c)
                legend.append(w_label)
                plt.subplot(221)
                plt.plot(test_len_arr, sof, time_colors[col_arr.index(c)], label=w_label, marker=marker_symbols[col_arr.index(c)])  # solid green
                plt.title('software')
                plt.subplot(222)
                plt.plot(test_len_arr, ser, time_colors[col_arr.index(c)], label=w_label, marker=marker_symbols[col_arr.index(c)])  # solid green
                plt.title('serial')
                plt.subplot(223)
                plt.plot(test_len_arr, par, time_colors[col_arr.index(c)], label=w_label, marker=marker_symbols[col_arr.index(c)])  # solid green
                plt.title('parallel')
                
    plt.subplots_adjust(top=0.95, bottom=0.06, left=0.09, right=0.95, hspace=0.25,
                    wspace=0.25)
    plt.legend(legend,loc=(1.5, 0.1))
    plt.savefig(IMAGE_PATH + 'column_'+str(r)+'_'+str(i)+'.png')
    plt.close()
    
    for r in row_arr:
        for c in col_arr:
            for i in int_range:
                soft, serial, parallel = fetch_result_time(r, c, i, over_flow="NO", max_tests=1000)
                test_len, sof, ser, par = normalize(soft, serial, parallel)
                test_len_arr = range(test_len)
                w_label= 'c='+str(c)
                percentage_ser = find_percentage(sof, ser)
                percentage_par = find_percentage(sof, par)
                percentage_par_ser = find_percentage(ser, par)
                legend.append(w_label)
                plt.subplot(221)
                plt.plot(test_len_arr, percentage_ser, time_colors[col_arr.index(c)], label=w_label, marker=marker_symbols[col_arr.index(c)])
                plt.title('% of serial wrt software')
                plt.subplot(222)
                plt.plot(test_len_arr, percentage_par, time_colors[col_arr.index(c)], label=w_label, marker=marker_symbols[col_arr.index(c)])
                plt.title('% of parallel wrt software')
                plt.subplot(223)
                plt.plot(test_len_arr, percentage_par_ser, time_colors[col_arr.index(c)], label=w_label, marker=marker_symbols[col_arr.index(c)])
                plt.title('% of parallel wrt serial')
                
    plt.subplots_adjust(top=0.95, bottom=0.06, left=0.09, right=0.95, hspace=0.25,
                    wspace=0.25)
    plt.legend(legend,loc=(1.5, 0.1))
    plt.savefig(IMAGE_PATH + 'column_'+str(r)+'_'+str(i)+'percentage.png')
    plt.close()
    

def compare_int():
    row_arr = [5]
    col_arr = [5]
    int_range = [20,15,10,5]
    legend = []
    for r in row_arr:
        for c in col_arr:
            for i in int_range:
                soft, serial, parallel = fetch_result_time(r, c, i, over_flow="NO", max_tests=1000)
                test_len, sof, ser, par = normalize(soft, serial, parallel)
                test_len_arr = range(test_len)
                w_label= 'int='+str(i)
                legend.append(w_label)
                plt.subplot(221)
                plt.plot(test_len_arr, sof, time_colors[int_range.index(i)], label=w_label, marker=marker_symbols[int_range.index(i)])
                plt.title('software')
                plt.subplot(222)
                plt.plot(test_len_arr, ser, time_colors[int_range.index(i)], label=w_label, marker=marker_symbols[int_range.index(i)])
                plt.title('serial')
                plt.subplot(223)
                plt.plot(test_len_arr, par, time_colors[int_range.index(i)], label=w_label, marker=marker_symbols[int_range.index(i)])
                plt.title('parallel')
                
    plt.subplots_adjust(top=0.95, bottom=0.06, left=0.09, right=0.95, hspace=0.25,
                    wspace=0.25)
    plt.legend(legend,loc=(1.5, 0.1))
    plt.savefig(IMAGE_PATH + 'int_'+str(r)+'_'+str(c)+'.png')
    plt.close()

    for r in row_arr:
        for c in col_arr:
            for i in int_range:
                soft, serial, parallel = fetch_result_time(r, c, i, over_flow="NO", max_tests=1000)
                test_len, sof, ser, par = normalize(soft, serial, parallel)
                test_len_arr = range(test_len)
                w_label= 'int='+str(i)
                percentage_ser = find_percentage(sof, ser)
                percentage_par = find_percentage(sof, par)
                percentage_par_ser = find_percentage(ser, par)
                legend.append(w_label)
                plt.subplot(221)
                plt.plot(test_len_arr, percentage_ser, time_colors[int_range.index(i)], label=w_label, marker=marker_symbols[int_range.index(i)])
                plt.title('% of serial wrt software')
                plt.subplot(222)
                plt.plot(test_len_arr, percentage_par, time_colors[int_range.index(i)], label=w_label, marker=marker_symbols[int_range.index(i)])
                plt.title('% of parallel wrt software')
                plt.subplot(223)
                plt.plot(test_len_arr, percentage_par_ser, time_colors[int_range.index(i)], label=w_label, marker=marker_symbols[int_range.index(i)])
                plt.title('% of parallel wrt serial')
                
    plt.subplots_adjust(top=0.95, bottom=0.06, left=0.09, right=0.95, hspace=0.25,
                    wspace=0.25)
    plt.legend(legend,loc=(1.5, 0.1))
    plt.savefig(IMAGE_PATH + 'int_'+str(r)+'_'+str(c)+'percentage.png')
    plt.close()

def main():
    compare_solver()
    compare_row()
    compare_col()
    compare_int()

if __name__ == '__main__':
    main()

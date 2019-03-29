#!/usr/bin/python3
#
# student: J.F.P. (Richard) Scholtens
# studentnr.: s2956586

import sys
import scipy.stats as stats


def check(list1, val): 
      
    # traverse in the list 
    for x in list1: 
        # compare with all the values 
        # with val 
        if val>= x: 
            return False 
    return True

def pvalue_check(val):
    if val < 0.05:
        print("There is a significant difference. The hypothesis is rejected.")
    else:
        print("There is no significant difference. The hypothesis accepted.")


def chi_square(fr, efr):
    """Returns the chi_square """ 
    return (fr - efr) /efr


def main(argv):

    if len(argv) == 12:


        total_word_c1 = int(argv[1])
        total_word_c2 = int(argv[2])
        total_word_r1 = int(argv[3])
        total_word_r2 = int(argv[4])
        total_word = int(argv[5])


        word1fr_0045 = int(argv[6])
        word1fr_4699 = int(argv[7])
        word2fr_0045 = int(argv[8])
        word2fr_4699 = int(argv[9])

        word1 = argv[10]
        word2 = argv[11]

        word_efr_c1r1 = (total_word_c1 + total_word_r1) / total_word
        word_efr_c1r2 = (total_word_c1 + total_word_r2) / total_word
        word_efr_c2r1 = (total_word_c2 + total_word_r1) / total_word
        word_efr_c2r2 = (total_word_c2 + total_word_r2) / total_word


        lst =  [word_efr_c1r1, word_efr_c1r2, word_efr_c2r1, word_efr_c2r2]

        m = [[word_efr_c1r1,word_efr_c2r1],[word_efr_c1r2,word_efr_c2r2]]
        if check(lst, 4) == True:
            print("Running Chi Square test.")

            chi2_stat, p_val, dof, ex = stats.chi2_contingency()
            print("===Chi2 Stat===")
            print(chi2_stat)
            print("\n")
            print("===Degrees of Freedom===")
            print(dof)
            print("\n")
            print("===P-Value===")
            print(p_val)
            print("\n")
            print("===Contingency Table===")
            print(ex)



        else:

            print("Running Fischer's Exact test because the expected frequency is to low.")
            
            oddsratio, pvalue = stats.fisher_exact(m)
            print('oddsratio: {0}'.format(oddsratio))
            print('p-value: {0}'.format(pvalue))
            pvalue_check(pvalue)




    else:
        print("Usage: ./chi_square.py", file=sys.stderr)
        exit(-1)

if __name__ == '__main__':
    main(sys.argv)

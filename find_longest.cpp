#include <iostream>
#include <fstream>
#include <vector>
#include <set>
#include <cmath>
#include <cstring>
#include <cstdio>
#include <cstdlib>
#include <omp.h>

using namespace std;

int ipow(int base, int exp, int k = -1) {
    int result = 1;
    if (k > 0) base %= k;
    while(exp) {
        if (exp & 1) {
            result *= base;
	    if (k > 0) result %= k;
        }
        exp >>= 1;
        base *= base;
	if (k > 0) base %= k;
    }
    return result;
}

int _log(int k, unsigned int x) {
  unsigned int ans = 0, y = x;
  while(x /= k) ans++;
  if((y - ipow(k, ans)) != 0) {
  	return -1;
	//~ throw "Bad!";
    }
  return ans ;
}

vector<int> make_vector(const char *str) {
    vector<int> data(strlen(str));
    for (int i = 0; i < strlen(str); ++i) {
        data[i] = str[i] - '0';
    }
    return data;
}

ostream& operator<<(ostream& out, const vector<int>& p) {
    for(int i = 0; i < p.size(); ++i) {
	out << p[i] << ' ';
    }
    out << endl;
    return out;
}

ostream& operator<<(ostream& out, const set<int>& p) {
    out << "{";
    for (std::set<int>::iterator it=p.begin(); it!= p.end(); ++it) {
	if (it != p.begin())
	    out << ',' << *it;
	else
	    out << *it;
    }
    out << "}" << endl;
    return out;
}

bool operator<=(const set<int> &a, const set<int> &b) {
    if (a.empty()) return true;
    for (std::set<int>::iterator it=a.begin(); it!= a.end(); ++it) {
	if (b.find(*it) == b.end())
	    return false;
    }
    return true;
}

vector<int> conv(int number, int base, int size) {
  vector<int> ret(size,0);
  int i = 0;
  do {
    ret[size - 1 - i++] = number % base;
    number = int(number / base);
  } while (number);

  return ret;
}

int aconv(vector<int> number, int base) {
    int ret = 0;
    int size = number.size() - 1;
    for (int i = 0; i < number.size(); ++i) {
	if (number[i])
	    ret += number[i] * ipow(base, size - i);
    }

    return ret;
}

int weight(const vector<int> &v) {
    int w = 0;
    for (int i = 0; i < v.size(); ++i) {
	w += v[i];
    }
    return w;
}

int len(const vector<int> &v) {
    int w = 0;
    for (int i = 0; i < v.size(); ++i) {
	w += bool(v[i]);
    }
    return w;
}

vector<int> restore_function(const vector<int> &period, int n, int k = 5) {
    vector<int> f = period;
    int l = period.size(), kn = ipow(k, n), times = (kn % l) ? kn / l : kn / l - 1;
    for (int i = 0; i < times; ++i) {
	f.insert(f.end(), period.begin(), period.end());
    }
    if (kn % l) {
	f.erase(f.begin() + kn, f.end());
    }
    
    return f;
}

vector<int> restore_vector(const vector<int> &period, int size) {
    vector<int> v = period;
    int l = period.size(), times = (size % l) ? size / l : size / l - 1;
    for (int i = 0; i < times; ++i) {
	v.insert(v.end(), period.begin(), period.end());
    }
    if (size % l) {
	v.erase(v.begin() + size, v.end());
    }
    return v;
}

set<int> makeI(const vector<int> &a) {
    set<int> I;

    for (int i = 0; i < a.size(); ++i) {
	if (a[i]) {
	    I.insert(i + 1);
	}

    }

    return I;
}

vector<vector<int> > make_all_Ekn(int k, int n) {
    vector<vector<int> > v(pow(k,n));
    for (int i = 0; i < v.size(); ++i) {
	v[i] = conv(i,k,n);
    }

    return v;
}

bool le(const vector<int> &a, const vector<int> &b) {
    if (a.size() != b.size()) throw "Bad size in eq!";
    for (int i = 0; i < a.size(); ++i) {
	if ((a[i] != 0) && (b[i] == 0))
	    return false;
    }
    return true;
}

vector<int> masked(const vector<vector<int> > &Ekn, const vector<int> &mask) {
    vector<int> v;
    for (int i = 0; i < Ekn.size(); ++i) {
	if (le(Ekn[i], mask))
	    v.push_back(i);
    }

    return v;
}

int sum(const vector<vector<int> > &Ekn, int k, const vector<int> &val, const vector<int> &a, const vector<int> &f) {
    int prod = 1, sum = 0;

    for (int i = 0; i < val.size(); ++i) {
	prod  = 1;
	for (int j = 0; j < a.size(); ++j) {
	    if (a[j]) {
		prod *= ipow(Ekn[val[i]][j], k - 1 - a[j], k);
		prod %= k;
	    }
	}
	if (prod < 0) {
	    cout<<"ipb = "<<i;
	    throw "";
	}
	prod *= f[aconv(Ekn[val[i]], k)];
	if (prod < 0) {
	    cout<<"ipa = "<<i<<" f[.] = "<<f[aconv(Ekn[val[i]], k)]<<" p = "<<prod;
	    throw "";
	}
	sum += prod;
	sum %= k;
    }

    return sum;
}

//changing f(x1,x2,...,xn) to f(x1-d1,x2-d2,...,xn-dn)
vector<int> polarize(const vector<int> &f, const vector<int> &d, int k) {
    vector<int> v(f.size()), tmp;
    int j;
    for (int i = 0; i < f.size(); ++i) {
	tmp = conv(i, k, d.size());
	for (int l = 0; l < tmp.size(); ++l) {
	    tmp[l] += (k - d[l]);
	    tmp[l] %= k;
	}
	j = aconv(tmp, k);
	v[j] = f[i];
    }

    return v;
}

vector<int> polynomial(vector<int> &f, const vector<int> &d, int k, int n, const vector<vector<int> > &Ekn) {
    //~ cout<<"lol\n";
    //~ cout<<f<<"d = "<<d<<k<<" "<<n<<endl;
    if (n == -1) throw "1err";
    if (d.size() != n) throw "2err";
    vector<int> c(f.size()), a;
    //~ vector<vector<int> > Ekn = make_all_Ekn(k,n);
    //~ cout<<"lol\n";
    //f = polarize(f,d,k);
    //~ cout<<"lol\n";
    bool number_non_zeros = false;
    //~ for (int i = 0; i < Ekn.size(); ++i) {cout<<Ekn[i];}
    set<int> I;
    //~ cout<<"lol\n";
    for (int i = 0; i < Ekn.size(); ++i) {
	//~ a = Ekn[i];
	c[i] = sum(Ekn, k, masked(Ekn, Ekn[i]), Ekn[i], polarize(f,d,k));
	//~ if (c[i] < 0) throw "Bada!";
	//~ cout<<"psum = "<<c[i]<<endl;
	number_non_zeros = false;
	for (int j = 0; j < Ekn[i].size(); ++j) {
	    if (Ekn[i][j]) number_non_zeros ^= 1;
	}
	if (number_non_zeros) {
	    c[i] *= -1;
	    c[i] = (c[i] >= 0)? c[i] % k : k + c[i] % k;
	}
	//~ cout<<string(sprintf("%d", i));
	//~ if (c[i] < 0) throw "Badb!";
    }

    return c;
}

bool is_little(vector<int> f, const vector<int> &d, int k, int n, const vector<vector<int> > &Ekn, int treshold) {
    //~ bool little = false;
    
    int max_zeros = f.size() - treshold + 1, ones = 0, zeros = 0;
    f = polarize(f,d,k);
    //~ cout<<"f= "<<f<<"d="<<d<<"treshold="<<treshold<<" max_zeros="<<max_zeros<<endl<<k<<n;
    for (int i = 0; i < Ekn.size(); ++i) {
	//~ cout<<"ones = "<<ones<<" zeros = "<<zeros<<endl;
	//~ cout<<"isum = "<<sum(Ekn, k, masked(Ekn, Ekn[i]), Ekn[i], f)<<endl;
	if (sum(Ekn, k, masked(Ekn, Ekn[i]), Ekn[i], f)) {
	    if (++ones >= treshold)
		return false;
	}
	else {
	    if(++zeros >= max_zeros)
		return true;
	}
	
    }
    //~ return little;
}

vector<vector<int> > make_polarizations(int n, int k = 5) {
    vector<vector<int> > polarizations;
    for (int i = 0; i < ipow(k, n); ++i) {
	polarizations.push_back(conv(i, k, n));
	//~ cout<<polarizations.back()<<endl;
    }
    return polarizations;
}

vector<vector<int> > make_periods(int k = 5, int l = 6) {
    vector<vector<int> > periods;
    for (int i = 0; i < ipow(k, l); ++i) {
	periods.push_back(conv(i, k, l));
	//~ cout<<periods.back()<<restore_function(periods.back(), 2, 3)<<endl;
    }
    return periods;
}

vector<int> vpow(const vector<int> &base, const vector<int> &exp, int k = -1) {
    if (base.size() != exp.size())
	throw "Error: different length in vpow";
    vector<int> result;
    for (int i = 0; i < base.size(); ++i) {
	result.push_back(ipow(base[i], exp[i], k));
    }
    
    return result;
}

int vmul(const vector<int> &v, int k = -1) {
    int res = 1;
    for (int i = 0; i < v.size(); ++i) {
	res *= v[i];
	if (k >= 0)
	    res %= k;
    }
    
    return res;
}

vector<int> func_from_poly(const vector<int> &p, const vector<vector<int> > &Ekn) {
    vector<int> f(p.size());
    int k = Ekn.back()[0] + 1;
    for (int i = 0; i < Ekn.size(); ++i) {
	for (int j = 0; j < Ekn.size(); ++j) {
	    f[i] += p[j] * vmul(vpow(Ekn[i], Ekn[j], k), k);
	    f[i] %= k;
	}
    }

    return f;
}

vector<int> func_from_weight(const vector<int> &w, const vector<vector<int> > &Ekn) {
    vector<int> f;
    for (int i = 0; i < Ekn.size(); ++i) {
	//~ if(weight(Ekn[i]) > w.size())
	    //~ cout<<"lol\n";
	f.push_back(w[weight(Ekn[i])]);
    }
    //~ cout<<"sz="<<f.size()<<endl;
    return f;
}

int main(int argc, char **argv) try {
    double lt = omp_get_wtime();
    int k = 5, n = 5, l = k - 1, treshold = (ipow(k, n+1) + ((n%2)?-1:1)) / (k+1), sum = 0, max_j = 0;
    vector<vector<int> > Ekn = make_all_Ekn(k,n), polarizations = make_polarizations(n, k);
    vector<int> vec1 = {1,1,4,4}, f1 = func_from_weight(restore_vector(vec1, (k-1) * n + 1), Ekn);
    //vector<int> vec2 = {1,4,4,1}, f2 = func_from_weight(restore_vector(vec2, (k-1) * n + 1), Ekn);
    //cout<<f;
    int min_len1 = len(polynomial(f1, polarizations[0], k, n, Ekn)), current_len1 = min_len1, min_idx = 0;
    //int min_len2 = len(polynomial(f2, polarizations[0], k, n, Ekn)), current_len2 = min_len2;
    //cout<<"LOL\n";
    //cout<<polynomial(f, d, k, n, Ekn);
    #pragma omp parallel for
    for (int i = 1; i < polarizations.size(); ++i) {
	current_len1 = len(polynomial(f1, polarizations[i], k, n, Ekn));
	//current_len2 = len(polynomial(f2, polarizations[i], k, n, Ekn));
	if (current_len1 < min_len1) {
	    min_len1 = current_len1;
	    min_idx = i;
	    cout<<"min_len1 = "<<min_len1<<endl;
	}
	/*if (current_len2 < min_len2) {
	    min_len2 = current_len2;
	    cout<<"min_len2 = "<<min_len2<<endl;
	}*/
    }

    cout<<endl;
    cout<<"Length = "<<min_len1<<endl;
    cout<<"Polarization = "<<min_idx<<endl;
    //cout<<"Length 2 = "<<min_len2<<endl;
    /*bool little = false;
    string fname = "longest_";
    fname += to_string(k) + '_' + to_string(n) + ".txt";
    ofstream out(fname);
    vector<int> f,g;
    vector<vector<int> > polarizations = make_polarizations(n, k), periods = make_periods(k, l);
    vector<vector<int> > Ekn = make_all_Ekn(k,n);
    //~ cout<<Ekn.back()<<weight(Ekn.back())<<endl;
    int array[2048], *func_short = new int[periods.size()];
    
    
#pragma omp parallel for
    for (int i = 0; i < 2048; ++i) {
	//~ cout<<omp_get_num_threads()<<endl;
	array[i] = -1;
    }
    
#pragma omp parallel for private(f, little)
    for (int i = 0; i < periods.size(); ++i) {
	//~ f = restore_function(periods[i], n, k);
	if (i != 174 && i != 246) continue;
	f = func_from_weight(restore_vector(periods[i], (k-1) * n + 1), Ekn);
	little = false;
	for (int j = 0; j < polarizations.size(); ++j) {
	    if (is_little(f, polarizations[j], k, n, Ekn, treshold)) {
		if (j > max_j) {
		    max_j = j;
		}
		func_short[i] = j;
		little = true;
		break;
	    }
	}
	if (!little) {
	    func_short[i] = -1;
	    array[sum++] = i;
	    cout<<"period = "<<periods[i];//<<restore_vector(periods[i], (k-1) * n + 1)<<"f = "<<f;
	}
    }
    int i = 0, tmp = array[0];
    while(tmp > 0) {
	out<<periods[tmp];
	tmp = array[++i];
    }
    for (int i = 0; i < periods.size(); ++i) {
	if (func_short[i] >= 0) {
	    //~ cout<<periods[i]<<func_from_weight(restore_vector(periods[i],(k-1)*n + 1), Ekn)<<polarizations[func_short[i]]<<endl;
	}
    }
    cout<<"sum = "<<sum<<endl;
    cout<<"max j = "<<max_j<<endl;
    printf("Time is equal %g\n", omp_get_wtime() - lt);
    out.close();*/
    printf("Time is equal %g\n", omp_get_wtime() - lt);
    return 0;
} catch(const char *err) {
    printf("%s\n", err);
    return 1;
}

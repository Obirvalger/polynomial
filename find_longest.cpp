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
  //~ int digits[] = {0,1,2,3,4,5,6,7,8,9};
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
	if (v[i])
	    w++;
    }
    return w;
}

vector<int> restore_function(const vector<int> &period, int n, int k = 5) {
    vector<int> f = period;
    //~ cout<<((9 % 2) ? 9 / 2 + 1 : 9 / 2)<<endl;
    int l = period.size(), kn = ipow(k, n), times = (kn % l) ? kn / l : kn / l - 1;
    //~ cout<<"times = "<<times<<" l = "<<l<<endl;
    for (int i = 0; i < times; ++i) {
	//~ cout<<"i = "<<i<<" sz = "<<f.size()<<endl;
	f.insert(f.end(), period.begin(), period.end());
    }
    //~ cout<<"sz = "<<f.size()<<endl;
    if (kn % l) {
	f.erase(f.begin() + kn, f.end());
    }
    //~ cout<<f.size()<<" kn = "<<kn<<"\n";
    return f;
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
    //~ cout<<"mask = "<<mask;
    for (int i = 0; i < Ekn.size(); ++i) {
	if (le(Ekn[i], mask))
	    v.push_back(i);
    }
    //~ cout<<"Ekn\n";
    //~ for (int i = 0; i < Ekn.size(); ++i) {cout<<Ekn[i];}
    //~ cout<<"v = "<<v;
    return v;
}

int sum(const vector<vector<int> > &Ekn, int k, const vector<int> &val, const vector<int> &a, const vector<int> &f) {
    int prod = 1, sum = 0;
    //~ cout<<f;
    for (int i = 0; i < val.size(); ++i) {
	prod  = 1;
	for (int j = 0; j < a.size(); ++j) {
	    if (a[j]) {
		prod *= ipow(Ekn[val[i]][j], k - 1 - a[j], k);
		prod %= k;
	    }
	    /*if (prod < 0) {
		cout<<"j = "<<j;
		throw "";
	    }*/
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
	/*if (sum < 0) {
	    cout<<"is = "<<i;
	    throw "";
	}*/
    }

    return sum;
}

//changing f(x1,x2,...,xn) to f(x1+d1,x2+d2,...,xn+dn)
vector<int> polarize(const vector<int> &f, const vector<int> &d, int k) {
    //~ cout<<f<<d<<k<<endl;
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
	/*if (v[j] < 0) {
	    cout<<"j = "<<j;
	    throw "";
	}*/
    }

    //~ cout<<"v = "<<v;
    return v;
}

vector<int> polynomial(vector<int> f, const vector<int> &d, int k, int n, const vector<vector<int> > &Ekn) {
    //~ cout<<"lol\n";
    //~ cout<<f<<"d = "<<d<<k<<" "<<n<<endl;
    if (n == -1) throw "1err";
    if (d.size() != n) throw "2err";
    vector<int> c(f.size()), a;
    //~ vector<vector<int> > Ekn = make_all_Ekn(k,n);
    //~ cout<<"lol\n";
    f = polarize(f,d,k);
    //~ cout<<"lol\n";
    bool number_non_zeros = false;
    //~ for (int i = 0; i < Ekn.size(); ++i) {cout<<Ekn[i];}
    set<int> I;
    //~ cout<<"lol\n";
    for (int i = 0; i < Ekn.size(); ++i) {
	//~ a = Ekn[i];
	c[i] = sum(Ekn, k, masked(Ekn, Ekn[i]), Ekn[i], f);
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

int main(int argc, char **argv) try {
    double lt = omp_get_wtime();
    int k = 7, n = 3, l = k + 1, w = 0, min_w, treshold = ipow(k, n+1) / (k+1), sum = 0, max_j = 0;
    //~ cout<<"tr = "<<treshold<<endl;
    bool little = false;
    string fname = "longest_";
    fname += to_string(k) + '_' + to_string(n) + ".txt";
    ofstream out(fname);
    vector<int> f;
    vector<vector<int> > polarizations = make_polarizations(n, k), periods = make_periods(k, l);
    vector<vector<int> > Ekn = make_all_Ekn(k,n);
    int array[2048];
    
    
#pragma omp parallel for
    for (int i = 0; i < 2048; ++i) {
	//~ cout<<omp_get_num_threads()<<endl;
	array[i] = -1;
    }
    
#pragma omp parallel for private(f, min_w, little, w)
    for (int i = 0; i < periods.size(); ++i) {
	f = restore_function(periods[i], n, k);
//~ #pragma omp single nowait
	//~ {
	    //~ printf("%d\n", i);
	//~ }
	//~ printf("i = %d\n", i);
	//~ min_w = weight(polynomial(f, polarizations[0], k, n, Ekn));
	little = false;
	for (int j = 0; j < polarizations.size(); ++j) {
	    //~ cout<<"i = "<<i<<" j = "<<j<<"\n";
	    //~ w = weight(polynomial(f, polarizations[j], k, n, Ekn));
	    //~ little = is_little(f, polarizations[j], k, n, Ekn, treshold);
	    //~ cout<<w<<" "<<treshold<<endl;
	    //~ if ((w < treshold) ^ little)
		//~ cout<<"All Bad!\n";
	    //~ cout<<"i="<<i<<" j="<<j<<endl;//" w="<<w<<" little="<<little<<" true="<<(!((w < treshold) ^ little))<<endl;
	    //~ cout<<"poly = "<<polynomial(f, polarizations[j], k, n, Ekn);
	    /*if (w < treshold) {
		little = true;
		//~ cout<<w<<"lol\n";
		break;
	    }*/
	    if (j > max_j) {
		//~ printf("j = %d\n", j);
		max_j = j;
	    }
	    if (is_little(f, polarizations[j], k, n, Ekn, treshold)) {
		little = true;
		break;
	    }
	    //~ if (w < min_w)
		//~ min_w = w;
	    //~ cout<<weight(polynomial(restore_function(periods[i], n, k), polarizations[j], k, n))<<endl;
	}
	//~ cout<<"period = "<<periods[i]<<"min = "<<min_w<<endl;
	if (!little) {
	    array[sum++] = i;
	    cout<<"period = "<<periods[i];//<<"min = "<<min_w<<endl;
	}
    }
    int i = 0, tmp = array[0];
    while(tmp > 0) {
	out<<periods[tmp];
	tmp = array[++i];
    }
    cout<<"sum = "<<sum<<endl;
    cout<<"max j = "<<max_j<<endl;
    printf("Time is equal %g\n", omp_get_wtime() - lt);
    out.close();
    return 0;
} catch(const char *err) {
    printf("%s\n", err);
    return 1;
}

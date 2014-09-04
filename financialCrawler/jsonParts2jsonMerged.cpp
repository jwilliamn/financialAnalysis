#include <iostream>
#include <map>
#include <vector>
#include <string>
#include <cstring>
#include <sstream>
using namespace std;

map<string,int> idToidx;
vector<vector<string> > M;
void addVector(){
	vector<string> tmp(12*3+2);
	M.push_back(tmp);
}
string cleanSpaces(string L){
	char K[L.size()+1];
	int tmp=0;
	for(int i=0;i<L.size();i++)
		if(L[i]!=' ')
			K[tmp++]=L[i];
	K[tmp]='\0';
	std::string mycppstr(K);
	return mycppstr;
}
pair<string,string> getNombreId(string L){
	int i=L.size()-1;
	int j=L.size()-1;
	while(i>=0 and L[i]!='(') i--;
	while(j>=0 and L[j]!=')') j--;
	string nombre=L.substr(0,i-1);	
	string id=L.substr(i+1,j-i-1);
	return make_pair(nombre,id);
}
std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems) {
    std::stringstream ss(s);
    std::string item;
    while (std::getline(ss, item, delim)) {
        elems.push_back(item);
    }
    return elems;
}


std::vector<std::string> split(const std::string &s, char delim) {
    std::vector<std::string> elems;
    split(s, delim, elems);
    return elems;
}
int main(){
	string L="";
	string tmp;
	while(getline(cin,tmp)!=NULL) L=L+tmp;
	//L=cleanSpaces(L);
	bool abierto=false;
	tmp="";
	vector<string> todo;
	for(int i=1;i<L.size()-1;i++){
		if(L[i]=='{' or L[i]=='}'){
		
		}else{ 
		
			if(L[i]=='"'){
				if(abierto){
					todo.push_back(tmp);
					tmp="";
					abierto=false;

				}else{
					abierto=true;
				}
			}else{
				if(L[i]=='['){
					abierto=true;
				}else{
					if(L[i]==']'){
						todo.push_back(tmp);
						tmp="";
						abierto=false;				
					}else{
						if(abierto){
							tmp=tmp+L[i];
						}
					}
				}
			}
		}
	}
	for(int i=1;i<todo.size();i+=6){
		pair<string,string> nombre_id=getNombreId(todo[i+2]);

		vector<string> data=split(cleanSpaces(todo[i+4]),',');
		int idx;
		if(idToidx.find(nombre_id.second)!=idToidx.end())
			idx=idToidx[nombre_id.second];
		else{
			addVector();
			idToidx[nombre_id.second]=M.size()-1;
			idx=M.size()-1;
			M[idx][0]=nombre_id.first;
			M[idx][1]=nombre_id.second;
		}
		int fact4;	
		if(todo[i].find("Cash+Flow")!=string::npos)
			fact4=0;

			
		else
			if(todo[i].find("Balance+Sheet")!=string::npos)
				fact4=1;
				else //incomeStatement
				fact4=2;	
		
		
			for(int k=0;k<12;k++)
				M[idx][fact4*4+(k/4)*12+k%4+2]=data[k];
				
	}
	cout<<"company Name\tid\t";
	for(int i=2013;i>=2011;i--){
		cout<<"totalCFOA"<<i<<"\ttotalCFIA"<<i<<"\ttotalCFFA"<<i<<"\tChangeCash"<<i<<"\t";
		cout<<"totalAssets"<<i<<"\tTotalLIabilities"<<i<<"\ttotalSHEQUITY"<<i<<"\tnetTangibleAssets"<<i<<"\t";
		cout<<"Revenue"<<i<<"\tGrossProfit"<<i<<"\tOperatingIncome"<<i<<"\tNetIncome"<<i<<"\t";
	}
	cout<<endl;
	for(int i=0;i<M.size();i++){
		for(int j=0;j<M[i].size();j++){
			cout<<M[i][j]<<"\t";
		}
		cout<<endl;
	}
	
return 0;}

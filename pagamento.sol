pragma solidity 0.4.25;

contract pagamentoSalario{
    
    address empresa;
    
    struct empregado {
        bool ativo;
        bool pago;
        uint salario;
        uint saldo;
    }
    
    event Transfer(address indexed de, address indexed para,uint valor);
    
    mapping(address => empregado) identificarEmpregado; 
    address[] listaEmpregados;
    
    //construcao do contrato
    function pagamentoSalario(){
        empresa = msg.sender;
    }
    
    //autoriza transacoes somente via conta da empresa
    modifier somenteEmpresa(){
       if(msg.sender != empresa){
           revert();
       }
        _;
    }
    
    //para adicionar novo empregado a lista de empregados da empresa
    function addEmployee(address novoEmpregado, uint salario) somenteEmpresa{
        var _empregado = identificarEmpregado[novoEmpregado];
        _empregado.ativo = true;
        _empregado.salario = salario;
        _empregado.saldo = 0;
        listaEmpregados.push(novoEmpregado);
    }
    
    //se o empregado deixar a empresa, usar esta funcao para torna-lo inativo
    function removerEmpregado(address _address) somenteEmpresa{
        identificarEmpregado[_address].ativo = false;
    }
    
    //para aumentar o salario do empregado
    function reajustaSalario(address _address, uint novoSalario) somenteEmpresa{
        identificarEmpregado[_address].salario = novoSalario;
    }
    
    function listarEmpregados() somenteEmpresa constant returns(address[]){
        return listaEmpregados;
    }
    
    //deposita o valor inicial combinado com a empresa
    function depositarSalario() somenteEmpresa payable{
     
    }
    
    function totalPago() somenteEmpresa constant returns(uint){
       return this.saldo;
    }
    
    //validado se o empregado ainda trabalha na empresa
    function estaAtivo(address check) constant returns(bool){
        return identificarEmpregado[check].ativo;
    }
    

    //envia o salario para a conta do empregado 
    function transfer(address _address) private{
       if(employeeMapper[_address].salary < this.balance){
           transferLog(_address);
           identificarEmpregado[_address].pago = true;
           identificarEmpregado[_address].saldo += identificarEmpregado[_address].salario;
       }else{
           identificarEmpregado[_address].pago = false;
       }
    }
    
    function transferLog(address _address) private{
        Transfer(msg.sender,_address,identificarEmpregado[_address].salario);
    }
    
    //primeiro checar se o empregado esta ativo e entao checar para duplo envio
    function enviaSalario(address enviaPara){
        if(estaAtivo(enviaPara) && !identificarEmpregado[enviaPara].pago){
            transfer(enviaPara);
        }
    } 
    
    
    function balanceOf(address empAd) public constant returns(uint){
        return identificarEmpregado[empAd].saldo;
    }
    
}

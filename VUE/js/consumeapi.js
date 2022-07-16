let app = new Vue({
el:'#app',
data:{
  titulo:'<h1 style="color:red;text-align:center;">Listado de roles</h1>',
  roles:[],
  api:'http://localhost/API_REST_VUE_PHP/PHP/api/api.php',
  rolname:'',
  title:'',
  titleButton:'',
  IdRol:'',
},
created() {
 this.mostrarRoles()
 
},
methods: {
mostrarRoles(){
axios.get(this.api).then(response=>{
this.roles=response.data
});
},
openModalCreateRol(){
    this.title='Crear Roles'
    this.titleButton='Guardar'
    $('#modalrol').modal('show')
},
openDialogEditarRol(id,nombrerol){
    this.title='Editar Roles'
    this.titleButton='Guardar cambios'
    this.IdRol=id
    this.rolname = nombrerol
    $('#modalrol').modal('show')
},
saveRol(){
(this.rolname!='')? 
axios.post(this.api,{namerol:this.rolname}).then(response=>{
if(response.data==1){
    MessageAlert("Mensaje del sistema","Rol creado correctamente","success")
this.mostrarRoles()
this.salir()
}else{
if(response.data==2){
    this.$refs.rolname.focus() 
    MessageAlert("Mensaje del sistema","No se permite datos duplicados","warning")
}else{
    MessageAlert("Mensaje del sistema","Acaba de ocurrir un error al crear roles","error")
}
this.rolname=''
}
}):
this.$refs.rolname.focus() 
MessageAlert("Mensaje del sistema","Complete el campo de nombre rol","error")
},
updateRol(){
    (this.rolname!='')? 
    axios.put(this.api,{namerol:this.rolname,id:this.IdRol}).then(response=>{
    if(response.data==1){
        MessageAlert("Mensaje del sistema","Rol modificado correctamente","success")
    this.mostrarRoles()
    this.rolname=''
    }else{
    if(response.data==2){
        MessageAlert("Mensaje del sistema","No se permite datos duplicados, error al modificar","warning")
    }else{
        MessageAlert("Mensaje del sistema","Acaba de ocurrir un error al modificar roles","error")
    }
    }
    }):this.$refs.rolname.focus() 
    MessageAlert("Mensaje del sistema","Complete el campo de nombre rol","error")
},
deleteRol(namerol,id){
    Swal.fire({
        title: 'Estas seguro?',
        text: "Deseas elimina el rol "+namerol,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Si, eliminar!'
      }).then((result) => {
        if (result.isConfirmed) {
          axios.delete(this.api+"?id="+id).then(respuesta=>{
            if(respuesta.data==1){
            MessageAlert("Mensaje del sistema","Rol eliminado","success")
            this.mostrarRoles()
            }else{
            MessageAlert("Mensaje del sistema","Error al eliminar rol","error")
            }
          });
        }
      })
},
salir(){
    $('#modalrol').modal("hide")
}
},
computed:{
   HiddenButton(){
    return this.titleButton;
   } 
}
});
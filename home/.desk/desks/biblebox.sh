cd ~/Projects/biblebox/

. ~/.ec2/peleteiro/credentials
. ~/.ec2/peleteiro/cloudflare
ssh-add ~/.ec2/peleteiro/biblebox.pem

export PROJ_DIR=~/Projects/biblebox

# Go to 
cdsysadmin() { cd $PROJ_DIR/sysadmin; }
cdandroid(){ cd $PROJ_DIR/android; }
cdsite(){ cd $PROJ_DIR/site; }
cddata(){ cd $PROJ_DIR/data; }
cdsearch(){ cd $PROJ_DIR/search; }
cdbaas(){ cd $PROJ_DIR/baas; }

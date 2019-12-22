//
//  ListController.m
//  infoArt
//
//  Created by mac mini on 17/8/15.
//  Copyright (c) 2015 obtcontrol. All rights reserved.
//

#import "ListController.h"

@interface ListController () <UITableViewDataSource, UITableViewDelegate>{
    Sin * sin;
    int chosen;
    NSMutableArray * numeros;
}

@end

@implementation ListController
@synthesize opciones;
@synthesize tipo;

- (void)viewDidLoad {
    [super viewDidLoad];
    sin=[Sin sharedInstance];
    self.tableViewAll.dataSource=self;
    self.tableViewAll.delegate=self;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ListMediaSegue"])
    {
        MediaViewController * controller=[segue destinationViewController];
        NSIndexPath * b=sender;
        NSString * clave;
        
        if (tipo==FAVORITOS){
            NSString * num=[sin.mapaNumerosInv[sin.idioma] objectForKey:opciones[b.row]];
            clave=[sin.mapaNumeros[0] objectForKey:num];
        }
        else if (tipo==DESTACADOS) clave=[sin.mapaNumeros[0] objectForKey:numeros[b.row]];
        controller.clave=clave;
        NSLog(@"%@",clave);
    }  else if([[segue identifier] isEqualToString:@"ListTextSegue"]){
        TextViewController * controller=[segue destinationViewController];
        switch (chosen) {
            case BUZON_SUGERENCIAS:
                controller.texto=@"";
                break;
            case SOBRE_APP:
                controller.texto=[NSString stringWithFormat:@"COMUN/INFOART%d.txt",sin.idioma];
                break;
            case INFO_MUSEO:
                controller.texto=[NSString stringWithFormat:@"COMUN/%@-INFOMUSEO%d.txt",sin.museo,sin.idioma];
                break;
            default:
                controller.texto=@"ERROR";
                break;
        }
        NSLog(@"1.0%@",controller.texto);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return opciones.count;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"OCell";
    OptionCell *cell  = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString* key=opciones[indexPath.row];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OptionCell" owner:self options:nil] objectAtIndex:0];
        cell.userInteractionEnabled = YES;
        cell.backgroundColor = [UIColor clearColor];
        cell.buttonGo.tag=indexPath.row;
        [cell.buttonGo addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell configWithOption:nil title:key];
    return cell;
}

#pragma mark - UITableViewDelegate
//TAP EVENT
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//-(void) didSelect:(UIButton*)sender
{
    NSInteger index=[indexPath row];//sender.tag;
    NSLog(@"INDEX1=%ld",(long)index);
    switch (tipo) {
        case MUSEOS:{ //Estamos en el menu de los museos y elegimos uno
            sin.museo=opciones[index];
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
        case VISITADOS:{
            if ([sin.user objectForKey:[NSString stringWithFormat:@"INFO%d%@",sin.idioma,opciones[index]]])
            {
                sin.museo=opciones[index];
                [Res obtenerListado];
                [self.navigationController popToRootViewControllerAnimated:true];
            }
            break;
        }
        case IDIOMAS:{
            sin.idioma=[[sin.dicIdiomas objectForKey:opciones[index]] intValue];
            [sin.user setObject:[NSString stringWithFormat:@"%d",sin.idioma] forKey:@"IDIOMA"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
        case DESTACADOS:{
            [self performSegueWithIdentifier:@"ListMediaSegue" sender:indexPath];
            [sin.stat add:true Lista:2 elem:numeros[index]];
            break;
        }
        case FAVORITOS:{
            [self performSegueWithIdentifier:@"ListMediaSegue" sender:indexPath];
            [sin.stat add:true Lista:3 elem:[sin.mapaNumerosInv[sin.idioma] objectForKey:opciones[index]]];
            break;
        }
        case OPCIONES:{ //estamos en el menu de las opciones y elegimos una
            NSLog(@"OPCIONES");
            switch (index) {
                case MAPA_MUSEO:{
                    [self performSegueWithIdentifier:@"ListMusMapSegue" sender:indexPath];
                    break;
                }
                case CUADROS_DESTACADOS:{
                    NSMutableArray * array=[[NSMutableArray alloc] init];
                    numeros=[[NSMutableArray alloc] init];
                    NSArray * aux=[[sin.user objectForKey:@"DESTACADOS"] componentsSeparatedByString:@">"];
                    for(NSString * string in aux){
                        NSArray * numbers=[string componentsSeparatedByString:@" "];
                        [array addObject:[NSString stringWithFormat:@"%@ %@❤",[sin.mapaNumeros[sin.idioma] objectForKey:numbers[0]],numbers[1]]];
                        [numeros addObject:numbers[0]];
                    }
                    tipo=DESTACADOS;
                    opciones=array;
                    [self.tableViewAll reloadData];
                    break;
                }
                case MIS_FAVORITOS:{
                    NSMutableArray * array=[[NSMutableArray alloc] init];
                    NSArray * aux=sin.stat.favoritos;
                    for(NSString * string in aux){
                        [array addObject:[sin.mapaNumeros[sin.idioma] objectForKey:string]];
                    }
                    opciones=array;
                    tipo=FAVORITOS;
                    [self.tableViewAll reloadData];
                    break;
                }
                case INFO_MUSEO:{
                    chosen=INFO_MUSEO;
                    [self performSegueWithIdentifier:@"ListTextSegue" sender:indexPath];
                    break;
                }
                case MUSEOS_VISITADOS:{
                    NSMutableArray * array=[[NSMutableArray alloc] init];
                    NSArray * aux=[sin.mapaMuseosLoc allKeys];
                    for(NSString * string in aux){
                        if ([sin.user objectForKey:[NSString stringWithFormat:@"CODIGO%@",string]])
                            [array addObject:string];
                    }
                    [array addObject:@"infoArt"];
                    opciones=array;
                    tipo=VISITADOS;
                    [self.tableViewAll reloadData];

                    break;
                }
                case MAPA_INFOART:{
                    [self performSegueWithIdentifier:@"ListRedMapSegue" sender:indexPath];
                    break;
                }
                case BUZON_SUGERENCIAS:{
                    chosen=BUZON_SUGERENCIAS;
                    [self performSegueWithIdentifier:@"ListTextSegue" sender:indexPath];
                    break;
                }
                case SOBRE_APP:{
                    chosen=SOBRE_APP;
                    [self performSegueWithIdentifier:@"ListTextSegue" sender:indexPath];
                    break;
                }
                default:
                    break;
            }
        }
        default:
            break;
    }
}


@end

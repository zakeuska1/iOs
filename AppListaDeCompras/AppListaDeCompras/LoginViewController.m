//
//  LoginViewController.m
//  AppListaDeCompras
//
//  Created by ALUNO on 08/11/16.
//  Copyright © 2016 IESB. All rights reserved.
//

#import "LoginViewController.h"
#import "Produto+CoreDataClass.h"
#import "AppDelegate.h"

@interface LoginViewController () <NSURLSessionDataDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usuario;
@property (weak, nonatomic) IBOutlet UITextField *senha;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *entrar;

@property (strong, nonatomic) NSMutableData *bytesResposta;

@end

@implementation LoginViewController

static NSString * const kChaveBancoCarregado = @"bancoCarregado";
CGFloat valorOriginalConstanteBotaoEntrar;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    valorOriginalConstanteBotaoEntrar = self.entrar.constant;
    
    [self.usuario setDelegate:self];
    [self.senha setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tecladoApareceu:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tecladoSumiu:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
    BOOL bancoCarregado = [[NSUserDefaults standardUserDefaults] boolForKey:kChaveBancoCarregado];
    
    if (!bancoCarregado) {
        self.bytesResposta = [NSMutableData new];
        
        NSURLSessionConfiguration *sc = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sc
                                                              delegate:self
                                                         delegateQueue:nil];
        
        NSURLSessionDataTask *taskProdutos = [session dataTaskWithURL: [NSURL URLWithString:@"https://mockaroo.com/9bf8ce80/download?count=10&key=9bcfbc80"]];
        
        [taskProdutos resume];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (void) tecladoApareceu: (NSNotification *) sender {
    NSDictionary* dicionarioDeInformacoesSobreTeclado = [sender userInfo];
    CGRect frameDoTeclado = [[dicionarioDeInformacoesSobreTeclado valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self.entrar setConstant: (valorOriginalConstanteBotaoEntrar + frameDoTeclado.size.height)];
    
}

- (void) tecladoSumiu: (NSNotification *) sender {
    [self.entrar setConstant:valorOriginalConstanteBotaoEntrar];
}


- (IBAction)validarLogin:(id)sender {
    
    //excluir após descomentar
    [self performSegueWithIdentifier:@"PrimeiraParaSegunda" sender:nil];
    
    //descomentar para publicar
    //
    //
    //
    //
    // if ([self.usuario.text isEqualToString: @"zacarias"] && [self.senha.text isEqualToString: @"junior"]){
    //     [self performSegueWithIdentifier:@"PrimeiraParaSegunda" sender:nil];
    // } else {
    //   UIAlertController *msgFalha = [UIAlertController alertControllerWithTitle:@"Falha ao logar" message:@"Usuário ou senha Incorreto" preferredStyle:UIAlertControllerStyleAlert];
        
    //  UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    //  [msgFalha addAction:ok];
        
    //  [self presentViewController:msgFalha animated:YES completion:nil];
    //}
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [self.bytesResposta appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error{
    
    if(error) {

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Falha ao Obter Dados"
                                                                                 message:@"Ocorreu um erro ao obter os dados dos produtos"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        NSError *erroJSON;
        
        NSDictionary *produtosRecebidos = [NSJSONSerialization JSONObjectWithData:self.bytesResposta
                                                                                     options:kNilOptions
                                                                                       error:&erroJSON];
        
        if(erroJSON) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Falha ao Ler os Dados"
                                                                                     message:@"O arquivo de produtos recebido é inválido"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else {
            AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context = delegate.managedObjectContext;
            
            
            
            
            
            for(NSDictionary *produto in produtosRecebidos) {
                
                Produto *novoProduto = [NSEntityDescription insertNewObjectForEntityForName:@"Produto" inManagedObjectContext:context];
                
                // Input
                //NSString *originalString = [produto objectForKey:@"quantidade"];
                
                // Intermediate
                //NSString *numberString;
                
                //NSScanner *scanner = [NSScanner scannerWithString:originalString];
                //NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
                
                // Throw away characters before the first number.
                //[scanner scanUpToCharactersFromSet:numbers intoString:NULL];
                
                // Collect numbers.
                //[scanner scanCharactersFromSet:numbers intoString:&numberString];
                
                //NSString *texto = numberString;
                //NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                //[formatter setNumberStyle:NSNumberFormatterNoStyle];
                
                //NSNumber *qtd = [formatter numberFromString:texto];
                
                
                
                NSString *foto = [produto objectForKey:@"foto"];
                foto = [[foto componentsSeparatedByString:@","] lastObject];
                NSData *bytes = [[NSData alloc] initWithBase64EncodedString:foto options:kNilOptions];
                
                [novoProduto setFoto:bytes];
                [novoProduto setNome:[produto objectForKey:@"nome"]];
                [novoProduto setMarca:[produto objectForKey:@"marca"]];
                [novoProduto setQuantidade:[produto objectForKey:@"quantidade"]];

            }
            
            //OCULTAR O NETWORK ACTIVITY INDICATION
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            NSError *erroCoreData;
            if (![context save:&erroCoreData]) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Erro"
                                                                                         message:@"Ocorreu um erro ao salvar os produtos recebidos."
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:nil]];
                
                NSLog(@"Erro ao realizar carga inicial: %@", erroCoreData);
                
            } else {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kChaveBancoCarregado];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

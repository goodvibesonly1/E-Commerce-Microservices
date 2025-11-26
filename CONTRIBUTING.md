# Contributing

Thanks for checking out this project! If you want to contribute, here's what you need to know.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)

## Code of Conduct

Pretty simple:
- Be respectful
- Help newcomers
- Focus on making the project better
- Don't be a jerk

## Getting Started

### Setup

Fork the repo and clone it:

```bash
git clone https://github.com/YOUR-USERNAME/ecom-ii-bdcc-app.git
cd ecom-ii-bdcc-app
```

Add the upstream remote:

```bash
git remote add upstream https://github.com/ORIGINAL-OWNER/ecom-ii-bdcc-app.git
```

Install what you need:
- Java 17+
- Maven 3.6+
- Node.js 18+
- Angular CLI: `npm install -g @angular/cli`

### Build the project

**Backend:**
```bash
cd micro-services-app
mvn clean install
```

**Frontend:**
```bash
cd angular-client
npm install
```

**Start everything:**
```bash
.\start-services.bat
```

## Development Workflow

Pretty standard Git workflow:

1. Create a branch:
   ```bash
   git checkout -b feature/add-something-cool
   # or for bugs:
   git checkout -b fix/broken-thing
   ```

2. Make your changes

3. Test them (seriously, test them)

4. Commit with a good message

5. Push to your fork:
   ```bash
   git push origin feature/add-something-cool
   ```

6. Open a PR

## Coding Standards

### Java/Spring Boot

Follow standard Spring Boot conventions:

- Use constructor injection, not field injection
- Keep controllers thin - logic goes in services
- Write JavaDoc for public APIs
- Follow REST conventions (GET for reads, POST for creates, etc.)

Example:

```java
@RestController
@RequestMapping("/api/products")
public class ProductController {
    
    private final ProductService productService;
    
    public ProductController(ProductService productService) {
        this.productService = productService;
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Product> getProduct(@PathVariable Long id) {
        return productService.findById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }
}
```

### TypeScript/Angular

Follow the [Angular style guide](https://angular.io/guide/styleguide):

- Use strict mode
- Clean up subscriptions in `ngOnDestroy`
- Use the async pipe when possible
- Keep components dumb, services smart

Example:

```typescript
@Component({
  selector: 'app-product-list',
  templateUrl: './product-list.component.html'
})
export class ProductListComponent implements OnInit, OnDestroy {
  products$: Observable<Product[]>;
  private destroy$ = new Subject<void>();
  
  constructor(private productService: ProductService) {}
  
  ngOnInit() {
    this.products$ = this.productService.getAll();
  }
  
  ngOnDestroy() {
    this.destroy$.next();
    this.destroy$.complete();
  }
}
```

### General rules

- Don't commit secrets (API keys, passwords, etc.)
- Use environment variables for config
- Comment complex logic
- Keep functions small and focused

## Commit Guidelines

We use [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat` - new feature
- `fix` - bug fix
- `docs` - documentation only
- `style` - formatting, missing semicolons, etc.
- `refactor` - code change that neither fixes a bug nor adds a feature
- `test` - adding tests
- `chore` - updating build tasks, package manager configs, etc.

**Examples:**

```
feat(products): add search by category

Users can now filter products by category through a dropdown
in the product list view.

Closes #45
```

```
fix(billing): correct tax calculation for EU orders

Tax was being applied twice for EU customers. Fixed by checking
the customer's region before applying regional tax rates.

Fixes #89
```

## Pull Request Process

Before submitting:

1. Update docs if you changed functionality
2. Add tests for new features
3. Make sure all tests pass:
   ```bash
   # Backend
   mvn test
   
   # Frontend
   cd angular-client
   npm test
   ```
4. Update README if needed
5. Make sure your code follows the style guide

**PR checklist:**
- [ ] Tests pass
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] Self-reviewed the code
- [ ] No console warnings/errors
- [ ] Added tests for new features

## Testing

### Backend

Write tests for your services and controllers:

```java
@Test
void shouldFindProductById() {
    Product product = new Product(1L, "Laptop", 999.99);
    when(productRepository.findById(1L)).thenReturn(Optional.of(product));
    
    Optional<Product> result = productService.findById(1L);
    
    assertTrue(result.isPresent());
    assertEquals("Laptop", result.get().getName());
}
```

Aim for >75% coverage on new code.

### Frontend

Test components and services:

```typescript
it('should load products', fakeAsync(() => {
  const mockProducts = [
    {id: 1, name: 'Widget', price: 29.99},
    {id: 2, name: 'Gadget', price: 49.99}
  ];
  
  spyOn(productService, 'getAll').and.returnValue(of(mockProducts));
  
  component.ngOnInit();
  tick();
  
  component.products$.subscribe(products => {
    expect(products.length).toBe(2);
  });
}));
```

## Adding Features

### New Microservice

1. Create the service in `micro-services-app/`
2. Add Eureka client dependency
3. Configure `application.properties` with a unique port
4. Add to parent `pom.xml`
5. Create config file in `config-repo/`
6. Update `start-services.bat`
7. Document it

### New API Endpoint

1. Add the endpoint to your service
2. Update Gateway routes if needed
3. Update Angular service if it's used by the UI
4. Write tests
5. Update API docs

## Questions?

- Check existing [issues](https://github.com/OWNER/ecom-ii-bdcc-app/issues)
- Look through the [docs](docs/)
- Open a new issue if you're stuck

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thanks for contributing!

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing Guidelines](#testing-guidelines)

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code:

- Be respectful and inclusive
- Welcome newcomers and help them learn
- Focus on what is best for the community
- Show empathy towards other community members

## Getting Started

### Prerequisites

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR-USERNAME/ecom-ii-bdcc-app.git
   cd ecom-ii-bdcc-app
   ```
3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/ORIGINAL-OWNER/ecom-ii-bdcc-app.git
   ```
4. Install dependencies:
   - Java 17+
   - Maven 3.6+
   - Node.js 18+
   - Angular CLI (`npm install -g @angular/cli`)

### Local Development Setup

1. **Backend Services**:
   ```bash
   cd micro-services-app
   mvn clean install
   ```

2. **Frontend**:
   ```bash
   cd angular-client
   npm install
   ```

3. **Start Services**:
   ```bash
   # From project root
   .\start-services.bat
   ```

## Development Workflow

1. **Create a branch** for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bugfix-name
   ```

2. **Make your changes** following the coding standards

3. **Test your changes** thoroughly

4. **Commit your changes** with meaningful messages

5. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Open a Pull Request** to the main repository

## Coding Standards

### Java/Spring Boot

- Follow [Spring Boot Best Practices](https://spring.io/guides)
- Use meaningful variable and method names
- Add JavaDoc comments for public methods
- Keep classes focused and single-responsibility
- Use dependency injection via constructor
- Follow RESTful API conventions

**Example**:
```java
@RestController
@RequestMapping("/api/customers")
public class CustomerRestController {
    
    private final CustomerService customerService;
    
    /**
     * Creates a new customer.
     * @param customer The customer to create
     * @return The created customer with ID
     */
    @PostMapping
    public ResponseEntity<Customer> createCustomer(@RequestBody Customer customer) {
        return ResponseEntity.ok(customerService.save(customer));
    }
}
```

### TypeScript/Angular

- Follow [Angular Style Guide](https://angular.io/guide/styleguide)
- Use TypeScript strict mode
- Implement OnDestroy for cleanup
- Use async pipe for observables in templates
- Keep components focused on presentation
- Move business logic to services

**Example**:
```typescript
@Component({
  selector: 'app-customers',
  templateUrl: './customers.component.html'
})
export class CustomersComponent implements OnInit, OnDestroy {
  customers$: Observable<Customer[]>;
  private destroy$ = new Subject<void>();
  
  constructor(private customerService: CustomerService) {}
  
  ngOnInit(): void {
    this.customers$ = this.customerService.getAllCustomers();
  }
  
  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }
}
```

### Configuration

- Never commit sensitive data (API keys, passwords)
- Use environment variables for configuration
- Document all configuration options
- Provide example configuration files

## Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/):

### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, semicolons, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Build process or auxiliary tool changes

### Examples

```bash
feat(customer-service): add customer search by email

Implemented new endpoint to search customers by email address.
Includes validation and error handling.

Closes #123
```

```bash
fix(billing-service): correct tax calculation

Fixed bug where tax was calculated incorrectly for international orders.

Fixes #456
```

## Pull Request Process

1. **Update documentation** if you're adding/changing features
2. **Add tests** for new functionality
3. **Ensure all tests pass**:
   ```bash
   # Backend
   mvn test
   
   # Frontend
   cd angular-client
   npm test
   ```
4. **Update the README.md** if necessary
5. **Fill out the PR template** with all required information
6. **Request reviews** from maintainers
7. **Address feedback** promptly and respectfully

### PR Checklist

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No new warnings generated
- [ ] Tests added/updated and passing
- [ ] Dependent changes merged and published

## Testing Guidelines

### Backend Testing

- Write unit tests for service layer
- Write integration tests for repositories
- Test REST endpoints with MockMvc
- Aim for >80% code coverage

**Example**:
```java
@Test
void testCreateCustomer() {
    Customer customer = new Customer(null, "John Doe", "john@example.com");
    Customer saved = customerService.save(customer);
    
    assertNotNull(saved.getId());
    assertEquals("John Doe", saved.getName());
}
```

### Frontend Testing

- Write unit tests for components
- Test services with HttpClientTestingModule
- Test user interactions
- Maintain >70% code coverage

**Example**:
```typescript
it('should load customers on init', () => {
  const mockCustomers = [{id: 1, name: 'Test', email: 'test@test.com'}];
  customerService.getAllCustomers.and.returnValue(of(mockCustomers));
  
  component.ngOnInit();
  
  expect(component.customers$).toBeDefined();
});
```

## Project-Specific Guidelines

### Adding a New Microservice

1. Create service in `micro-services-app/`
2. Add Eureka client dependency
3. Add Config client dependency
4. Configure `application.properties`
5. Add module to parent `pom.xml`
6. Create config file in `config-repo/`
7. Update startup scripts
8. Document in README.md

### Adding API Endpoints

1. Add endpoint in service
2. Register route in Gateway
3. Update Angular service if needed
4. Add to API documentation
5. Write tests
6. Update relevant docs

## Questions?

- Check [existing issues](https://github.com/OWNER/ecom-ii-bdcc-app/issues)
- Review [documentation](docs/)
- Open a new issue for discussion

## License

By contributing, you agree that your contributions will be licensed under the project's MIT License.

---

Thank you for contributing! 🎉

---
name: deploy
description: Guides through the deployment checklist and executes deployment steps for the appropriate environment.
---

# /deploy

Run pre-deployment checks and deploy the application to the target environment.

## Usage

```
/deploy staging
/deploy production
/deploy --dry-run production
```

## Pre-Deploy Checklist

- [ ] All tests pass (`pnpm test`)
- [ ] No TypeScript errors (`pnpm typecheck`)
- [ ] Linting passes (`pnpm lint`)
- [ ] Environment variables are set in the target environment
- [ ] Database migrations are ready (if applicable)
- [ ] Feature flags are configured correctly
- [ ] CHANGELOG.md is updated

## Deployment Steps

### Staging
1. Merge feature branch to `develop`
2. CI pipeline runs automatically
3. Preview URL is posted in Slack / PR

### Production
1. Merge `develop` → `main` via PR
2. Confirm all checks pass
3. Tag the release: `git tag v1.x.x`
4. CI/CD deploys automatically on push to `main`
5. Monitor error rates for 10 minutes post-deploy

## Rollback

If issues are detected post-deploy:
```bash
git revert HEAD && git push
# or via platform dashboard: redeploy previous build
```

---
icon: truck-container
---

# Docker Image Delivery

## Docker Image Delivery: Free Options

### **1. Docker Hub (Free Tier)**

* **Free public repositories**: Unlimited
* **Free private repositories**: 1 private repository
* **Best for**: Public images or small-scale private distribution
*   **How to deliver**:

    ```bash
    # Push images
    docker tag your-image:version username/hec-model-name:version
    docker push username/hec-model-name:version

    # Client pulls
    docker pull username/hec-model-name:version
    ```

### **2. GitHub Container Registry (GHCR)**

* **Free**: Unlimited public images, 500MB private storage for free accounts
* **Best for**: Projects already on GitHub
* **Integration**: Works seamlessly with GitHub Actions for CI/CD
*   **How to deliver**:

    ```bash
    # Push images
    docker tag your-image:version ghcr.io/username/hec-model-name:version
    docker push ghcr.io/username/hec-model-name:version

    # Client pulls (public images)
    docker pull ghcr.io/username/hec-model-name:version
    ```

### **3. Self-Hosted Registry**

* **Free**: Deploy your own Docker registry
* **Best for**: Full control, on-premises delivery
* **Options**:
  * Docker Registry (official)
  * Harbor (enterprise features)
  * GitLab Container Registry (if using GitLab)

### **4. Cloud Provider Free Tiers**

* **AWS ECR**: 500MB storage free for 12 months
* **Google Artifact Registry**: 0.5GB free storage
* **Azure Container Registry**: Basic tier available

### **5. Direct File Transfer**

*   **For air-gapped/offline clients**:

    ```bash
    # Save image to tar file
    docker save -o hec-model-v1.tar your-image:v1

    # Client loads image
    docker load -i hec-model-v1.tar
    ```
* **Best for**: Clients without internet access or strict security requirements





### **Recommended Approach for Multi-image, Multi-version Scenario**

**For ongoing delivery**: Use **GitHub Container Registry**

* Tag images with model name and version: `ghcr.io/shadhini/hec-ras:v6.3`, `ghcr.io/shadhini/hec-hms:v4.9`
* Automate builds with GitHub Actions
* Clients pull specific versions as needed

**For one-time/infrequent delivery**: Use **Docker save/load**

* Bundle all images into tar files
* Transfer via secure file sharing (Dropbox, Google Drive, etc.)
* No registry maintenance required


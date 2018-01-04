Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47951 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750770AbeADIaN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 03:30:13 -0500
Date: Thu, 4 Jan 2018 09:30:11 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 15/18] mm, fs, dax: use page->mapping to warn if dma
        collides with truncate
Message-ID: <20180104083011.GK2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com> <151407704063.38751.15403501871756055025.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151407704063.38751.15403501871756055025.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

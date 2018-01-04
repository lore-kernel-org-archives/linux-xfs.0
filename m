Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47977 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751294AbeADIba (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Jan 2018 03:31:30 -0500
Date: Thu, 4 Jan 2018 09:31:29 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 17/18] mm, fs, dax: dax_flush_dma, handle dma vs
        block-map-change collisions
Message-ID: <20180104083129.GM2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com> <151407705124.38751.12934858054023659736.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151407705124.38751.12934858054023659736.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, Matthew Wilcox <mawilcox@microsoft.com>, Dave Hansen <dave.hansen@linux.intel.com>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org, Jeff Moyer <jmoyer@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, ross.zwisler@linux.intel.com, hch@lst.de

Not pretty, but probably the best we can do for now..

Reviewed-by: Christoph Hellwig <hch@lst.de>

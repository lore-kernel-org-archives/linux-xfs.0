Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41804 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751135AbdEaTkO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 May 2017 15:40:14 -0400
Date: Wed, 31 May 2017 21:40:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/24] uuid: rename uuid_to_bin to uuid_parse
Message-ID: <20170531194012.GC6906@lst.de>
References: <20170531161826.23243-1-hch@lst.de> <20170531161826.23243-9-hch@lst.de> <1496254475.28981.36.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1496254475.28981.36.camel@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org

On Wed, May 31, 2017 at 09:14:35PM +0300, Andy Shevchenko wrote:
> On Wed, 2017-05-31 at 18:18 +0200, Christoph Hellwig wrote:
> > This matches the userspace version of it, and describes the
> > functionality
> > much better.  Also do the same for the guid version.
> > 
> 
> No objections for renaming, though I'm pretty sure it should be squashed
> to patch 6.

Fine with me, it just seemed like a unrelated enough change to justify
keeping it separate.

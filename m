Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25376 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932275AbdJZSWI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 14:22:08 -0400
Date: Thu, 26 Oct 2017 12:22:05 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and
 MAP_SYNC
Message-ID: <20171026182205.GA8048@linux.intel.com>
References: <20171024152415.22864-1-jack@suse.cz>
 <20171024152415.22864-19-jack@suse.cz>
 <20171024211007.GA1611@linux.intel.com>
 <20171026132402.GB31161@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171026132402.GB31161@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, linux-nvdimm@lists.01.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-api@vger.kernel.org, linux-mm@kvack.org

On Thu, Oct 26, 2017 at 03:24:02PM +0200, Jan Kara wrote:
> On Tue 24-10-17 15:10:07, Ross Zwisler wrote:
> > On Tue, Oct 24, 2017 at 05:24:15PM +0200, Jan Kara wrote:
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > This looks unchanged since the previous version?
> 
> Ah, thanks for checking. I forgot to commit modifications. Attached is
> really updated patch.
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

> From 59eeec2998ed9b3840aab951f213148cb1d053a5 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Thu, 19 Oct 2017 14:44:55 +0200
> Subject: [PATCH] mmap.2: Add description of MAP_SHARED_VALIDATE and MAP_SYNC
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks good, you can add: 

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

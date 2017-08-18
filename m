Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:3368 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751843AbdHRWIx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 18 Aug 2017 18:08:53 -0400
Date: Fri, 18 Aug 2017 16:08:52 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 05/13] dax: Create local variable for vmf->flags &
 FAULT_FLAG_WRITE test
Message-ID: <20170818220851.GD32627@linux.intel.com>
References: <20170817160815.30466-1-jack@suse.cz>
 <20170817160815.30466-6-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170817160815.30466-6-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Boaz Harrosh <boazh@netapp.com>

On Thu, Aug 17, 2017 at 06:08:07PM +0200, Jan Kara wrote:
> There are already two users and more are coming.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Sure, and this is much nicer to read.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

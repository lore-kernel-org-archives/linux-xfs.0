Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:12229 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751616AbdG0V6A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jul 2017 17:58:00 -0400
Date: Thu, 27 Jul 2017 15:57:57 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/7] mm: Remove VM_FAULT_HWPOISON_LARGE_MASK
Message-ID: <20170727215757.GB22000@linux.intel.com>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-2-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170727131245.28279-2-jack@suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>, Andy Lutomirski <luto@kernel.org>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>

On Thu, Jul 27, 2017 at 03:12:39PM +0200, Jan Kara wrote:
> It is unused.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

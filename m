Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49325 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753273AbdJPPOs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Oct 2017 11:14:48 -0400
Date: Mon, 16 Oct 2017 17:14:46 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 17/19] ext4: Add support for MAP_SYNC flag
Message-ID: <20171016151446.GI9762@quack2.suse.cz>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-18-jack@suse.cz>
 <20171013072123.GF9105@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171013072123.GF9105@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ted Tso <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri 13-10-17 00:21:23, Christoph Hellwig wrote:
> This really should be part of the previous patch.

Fair enough, I'll fold it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

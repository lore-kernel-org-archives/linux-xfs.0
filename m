Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 19A0A7CA0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 18:19:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0C00AC004
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 16:19:02 -0700 (PDT)
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
	[140.211.169.12]) by cuda.sgi.com with ESMTP id
	xm2KFseB7HR6i9Sj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 16:18:59 -0700 (PDT)
Date: Wed, 20 Jul 2016 16:18:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] dax: some small updates to dax.txt documentation
Message-Id: <20160720161857.a60913d6fae98c4c594e2e51@linux-foundation.org>
In-Reply-To: <20160720171302.13e14a0d@lwn.net>
References: <20160714214049.20075-1-ross.zwisler@linux.intel.com>
	<20160720171302.13e14a0d@lwn.net>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jonathan Corbet <corbet@lwn.net>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-doc@vger.kernel.org, linux-nvdimm@ml01.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Wed, 20 Jul 2016 17:13:02 -0600 Jonathan Corbet <corbet@lwn.net> wrote:

> On Thu, 14 Jul 2016 15:40:48 -0600
> Ross Zwisler <ross.zwisler@linux.intel.com> wrote:
> 
> > These are originally from Matthew Wilcox and were part of his huge
> > "mm,fs,dax: Change ->pmd_fault to ->huge_fault" patch that was part of PUD
> > support.
> > 
> > I'm breaking these small changes out as they stand on their own and add
> > useful information to Documentation/filesystems/dax.txt.
> 
> So how were you thinking of routing these?  I can take the docs fix, of
> course, but part 2 is a bit out of my turf.  If you want to route them
> together via another tree that's fine, just let me know.

I have them queued.  You were cc'ed on the commit!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

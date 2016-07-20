Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A8937CA0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 18:13:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3DF658F8033
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 16:13:08 -0700 (PDT)
Received: from vena.lwn.net (tex.lwn.net [70.33.254.29]) by cuda.sgi.com with
	ESMTP id nrDSniBkc0vYAzw5 (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 16:13:06 -0700 (PDT)
Date: Wed, 20 Jul 2016 17:13:02 -0600
From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 1/2] dax: some small updates to dax.txt documentation
Message-ID: <20160720171302.13e14a0d@lwn.net>
In-Reply-To: <20160714214049.20075-1-ross.zwisler@linux.intel.com>
References: <20160714214049.20075-1-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-doc@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Thu, 14 Jul 2016 15:40:48 -0600
Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> These are originally from Matthew Wilcox and were part of his huge
> "mm,fs,dax: Change ->pmd_fault to ->huge_fault" patch that was part of PUD
> support.
> 
> I'm breaking these small changes out as they stand on their own and add
> useful information to Documentation/filesystems/dax.txt.

So how were you thinking of routing these?  I can take the docs fix, of
course, but part 2 is a bit out of my turf.  If you want to route them
together via another tree that's fine, just let me know.

Thanks,

jon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

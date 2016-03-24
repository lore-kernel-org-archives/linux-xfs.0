Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ADA767CA1
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 18:23:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5F46D304051
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 16:23:35 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id nrBDkLBoQ8YBumaQ for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 16:23:34 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 3/5] dax: enable dax in the presence of known media
	errors (badblocks)
Date: Thu, 24 Mar 2016 23:23:26 +0000
Message-ID: <1458861805.7619.1.camel@intel.com>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
	<1458861450-17705-4-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1458861450-17705-4-git-send-email-vishal.l.verma@intel.com>
Content-Language: en-US
Content-ID: <A001440F8D6C3C4CB24CFB5EC465E195@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "Wilcox,
	Matthew R" <matthew.r.wilcox@intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>

On Thu, 2016-03-24 at 17:17 -0600, Vishal Verma wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> From: Dan Williams <dan.j.williams@intel.com>

Eep, not sure how this happened, looked alright in the patches!
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

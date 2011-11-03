Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3EtpRF020594 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 09:55:51 -0500
Received: from newverein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9136412FF996
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 07:55:50 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id Ip3qNYMmtvCUO0IK for
	<xfs@oss.sgi.com>; Thu, 03 Nov 2011 07:55:50 -0700 (PDT)
Date: Thu, 3 Nov 2011 15:55:49 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/12] Bunch of new stress tests -v4
Message-ID: <20111103145549.GA8612@lst.de>
References: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1320330301-2682-1-git-send-email-dmonakhov@openvz.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, aelder@sgi.com, tytso@mit.edu, xfs@oss.sgi.com

On Thu, Nov 03, 2011 at 06:24:49PM +0400, Dmitry Monakhov wrote:
> Changes from v3 ( in request to  Christoph's comments)
>  - hard code fsstress's options for explicit regression tests
>  - add two new regression tests

I already have commited your first three patches to the kernel.org
repository and various other tests that have used the nubers you're
using.  If you want to get it in ASAP please resend, otherwise I will
do it once I get a bit time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16LfkL2167449 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 15:41:48 -0600
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id 8olFDNGtG3uwsdqi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Feb 2012 13:41:45 -0800 (PST)
Date: Mon, 6 Feb 2012 16:41:32 -0500
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Message-ID: <20120206214132.GA22019@thunk.org>
References: <4F2D8F30.3090802@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F2D8F30.3090802@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

Cool!  I assume you're going to try to get this into util-linux-ng?

I'm tempted to drop it in e2fsprogs's contrib directxory for now, but
I think the best home for it is util-linux-ng.

							- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

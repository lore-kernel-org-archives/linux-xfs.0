Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCEYMlG103559 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 08:34:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2F711EAB36E
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 06:34:21 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	VqTDx4ecp724IK7y for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 06:34:21 -0800 (PST)
Date: Mon, 12 Dec 2011 09:34:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] xfs: serialise unaligned direct IOs
Message-ID: <20111212143421.GA13223@infradead.org>
References: <CADDb1s0WUfvt8N+hMATboKxbMUZdk2N-R2e=KFH2JvGUjbigBg@mail.gmail.com>
	<20111103070246.GA10579@infradead.org>
	<CADDb1s3UN4HMKEA2kSEM0HsUCC7DE63B1oJAoL6QpqXBdDCEqQ@mail.gmail.com>
	<20111103100647.GA1002@infradead.org>
	<CADDb1s2ZiPqHqkm01eG24jD+ytU9w3vJwKckXneMkL0wbUEb1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADDb1s2ZiPqHqkm01eG24jD+ytU9w3vJwKckXneMkL0wbUEb1Q@mail.gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Did you manage to submit this on for the 2.6.35 longterm releases?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

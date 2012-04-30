Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3UJCMN8022827 for <xfs@oss.sgi.com>; Mon, 30 Apr 2012 14:12:25 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	a7ajHt3wifsjz2m7 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 Apr 2012 12:12:19 -0700 (PDT)
Date: Mon, 30 Apr 2012 15:12:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Cleancache support in XFS
Message-ID: <20120430191218.GA23530@infradead.org>
References: <20120430173112.GA16257@beaver>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120430173112.GA16257@beaver>
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
To: Alexey Vlasov <renton@renton.name>
Cc: xfs@oss.sgi.com

On Mon, Apr 30, 2012 at 09:31:12PM +0400, Alexey Vlasov wrote:
> Hi.
> 
> Could you please tell me if you are planning to support cleancache in
> XFS?
> And when will it take place approximately?

As soon as someone submits a patch.  In theory it should just work, but
the cleancache maintainer require a completely idiotic one liner to
actually enable it.  Feel free to submit it once you actually tested it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

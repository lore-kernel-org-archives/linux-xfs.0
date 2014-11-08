Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 639127F3F
	for <xfs@oss.sgi.com>; Sat,  8 Nov 2014 00:40:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 345938F8033
	for <xfs@oss.sgi.com>; Fri,  7 Nov 2014 22:40:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id QYCxMTvDPxaYBZmO (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Nov 2014 22:40:34 -0800 (PST)
Date: Fri, 7 Nov 2014 22:40:33 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: beginners project: RENAME_WHITEOUT
Message-ID: <20141108064033.GA3450@infradead.org>
References: <20141107190959.GB21021@infradead.org>
	<545D4EE5.6040901@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <545D4EE5.6040901@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Carlos Maiolino <cem@maiolino.org>, xfs@oss.sgi.com

On Fri, Nov 07, 2014 at 04:59:49PM -0600, Eric Sandeen wrote:
> On 11/7/14 1:09 PM, Christoph Hellwig wrote:
> > The overlayfs merge introduces a new rename flag to create to whiteouts.
> > Should be a fairly easy to implement.
> > 
> > Miklos, do you have any good documentation and/or test cases for this?
> 
> FWIW, Carlos just expressed some interest today in doing this, and it
> builds on his earlier patches, yes?

It's in the same area, but not otherwise related.  But I'd be happy if
he picks it up.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

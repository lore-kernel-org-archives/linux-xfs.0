Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 266D87F56
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 08:55:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2759304070
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 06:54:59 -0800 (PST)
Date: Mon, 25 Nov 2013 06:54:56 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V4] xfsprogs: update version for 3.2.0-alpha2
Message-ID: <20131125145456.GA1394@infradead.org>
References: <20131118150313.940966335@sgi.com>
	<20131122183757.113479216@sgi.com> <528FC827.7080100@redhat.com>
	<529361CD.7060902@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <529361CD.7060902@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

On Mon, Nov 25, 2013 at 08:42:21AM -0600, Rich Johnston wrote:
> 
> >
> ><snip>
> >
> >>  xfsprogs-3.2.0-alpha1 (26 September 2013)
> >>-	- Alpha release for the purpose of testing the CRC feature during the
> >>-	  v3.12 kernel -rc series.
> >>+	- Alpha release for the purpose of testing the CRC feature in
> >>+	  kernels 3.10 and newer.
> >>+	- Remove all vestiges of old, unsupported version 1 directory code.
> >>+	- Add a ???readdir??? command to xfs_io, thanks to Brian Foster.
> >                 ^^^       ^^
> >That got a bit weird, probably my fault.
> Will fix at commit time.
> 
> Need a 3rd party Reviewed-by: so I can get this committed please.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

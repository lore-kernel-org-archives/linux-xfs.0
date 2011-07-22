Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MEsBZ2090008 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 09:54:11 -0500
Subject: Re: [PATCH, RFC] xfs: rename "linux-2.6" subdirectory to be simply
	"linux"
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110722143420.GE19681@infradead.org>
References: <201107211804.p6LI4Rvf006075@stout.americas.sgi.com>
	<20110722143420.GE19681@infradead.org>
Date: Fri, 22 Jul 2011 09:53:54 -0500
Message-ID: <1311346434.2771.17.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, 2011-07-22 at 10:34 -0400, Christoph Hellwig wrote:
> Actually it should just go away.  It's a leftover from when we had
> code for Linux 2.4 and Linux 2.6 in the same ptools repository. 

So this is an admission that XFS has gone from an
Irix-only to a Linux-only filesystem?  We have
strayed from it but I think there is value in
trying to separate the core platform-independent
part of the code from the part that interfaces
with the OS environment.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

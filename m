Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1ODKZeC144322 for <xfs@oss.sgi.com>; Tue, 24 Feb 2009 07:20:36 -0600
Date: Tue, 24 Feb 2009 08:20:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs/xfsdump release process
Message-ID: <20090224132003.GC1579@infradead.org>
References: <200902221348.51905.vapier@gentoo.org>
	<20090223072207.GA4112@infradead.org>
	<DCA2D97E-F9A4-4A9E-BC39-CFFF1D0AD2CD@sgi.com>
	<200902231125.44076.vapier@gentoo.org>
	<FF190F30-2ECF-49D7-B63F-EF65C076EC7A@sgi.com>
	<49A2F933.3090308@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49A2F933.3090308@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Frysinger <vapier@gentoo.org>, xfs-oss <xfs@oss.sgi.com>

On Mon, Feb 23, 2009 at 01:29:55PM -0600, Eric Sandeen wrote:
> Just FWIW, Fedora does similar.  Changing md5sums on a released,
> versioned tarball could set off all sorts of worries for distributions,
> in general...

Yeah.  Guys, what about declaring the 3.0.0 releases officially botched
and get 3.0.1 out next week?  That should include all the small fixes
we have out now and whatever small stuff comes up from distros trying
to use it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

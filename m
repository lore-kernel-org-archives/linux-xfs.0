Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9NCUboW045790 for <xfs@oss.sgi.com>; Tue, 23 Oct 2012 07:30:37 -0500
Date: Tue, 23 Oct 2012 08:32:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: master branch fast-forwarded to v3.7-rc1, and corp-speak mumble
Message-ID: <20121023123219.GH7341@infradead.org>
References: <20121016155640.GA1377@sgi.com>
 <507F132B.30000@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <507F132B.30000@sandeen.net>
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
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Wed, Oct 17, 2012 at 03:20:59PM -0500, Eric Sandeen wrote:
> Dave had concerns that a regression, which, although quickly fixed, was
> cited as the reason for missing a merge window.
> 
> This concerns me too, because it's not just SGI's timetables that matter
> here; others are also depending on this work getting upstream within certain
> deadlines as well.
> 
> Reading back through the list, I'm alarmed that SGI wants some unspecified
> "soak time," but not upstream, for new work.  There's no better place than
> an -rc1 to get soak & exposure for tested patches.  Bugs get found and fixed.
> I don't think the XFS developer community needs a lecture on patch submission
> processes and quality expectations.

The best place is the for-next branch.  We should aim for getting
patches in early in the window rather than last minute, which is way to
common in XFS land.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

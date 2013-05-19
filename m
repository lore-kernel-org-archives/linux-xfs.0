Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5DA347F37
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 02:59:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 45E5D8F8037
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 00:59:13 -0700 (PDT)
Received: from mail.qboosh.pl (mail.qboosh.pl [217.73.31.61]) by cuda.sgi.com
	with ESMTP id j7l0WqqrodRWlVJ9 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 00:59:11 -0700 (PDT)
Date: Sun, 19 May 2013 09:59:51 +0200
From: Jakub Bogusz <qboosh@pld-linux.org>
Subject: Re: Polish translation update for xfsprogs 3.1.11 and xfsdump 3.1.3
Message-ID: <20130519075951.GA3070@mail>
References: <20130514142827.GD32293@stranger.qboosh.pl>
	<20130517020017.GL24635@dastard>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130517020017.GL24635@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, May 17, 2013 at 12:00:17PM +1000, Dave Chinner wrote:
> On Tue, May 14, 2013 at 04:28:27PM +0200, Jakub Bogusz wrote:
> > Hello,
> > 
> > I updated Polish translations for xfsprogs 3.1.11 and xfsdump 3.1.3.
> > They are available at:
> > http://qboosh.pl/pl.po/xfsprogs-3.1.11.pl.po
> > http://qboosh.pl/pl.po/xfsdump-3.1.3.pl.po
> 
> Thanks, Jakub.
> 
> Out of interest, is there any way we can let you know about an
> upcoming release so we can get translations done before the release
> and hence ship them in the released package?

You can mail me before the release, preferably attaching latest .pot
file or pl.po after doing "make update-po".
Christoph does so sometimes.

You can also consider using TP (http://translationproject.org/)
to maintain translations. This way you could probably gather
translations to more languages.


Regards,

-- 
Jakub Bogusz    http://qboosh.pl/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

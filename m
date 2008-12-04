Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4DlOrD002492 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 07:47:26 -0600
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D886D167DA45
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2008 05:47:23 -0800 (PST)
Received: from rv-out-0708.google.com (rv-out-0708.google.com
	[209.85.198.245]) by cuda.sgi.com with ESMTP id
	Yt1gYUjVGnvHvpzJ for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2008 05:47:23 -0800 (PST)
Received: by rv-out-0708.google.com with SMTP id f25so3791578rvb.32
	for <xfs@oss.sgi.com>; Thu, 04 Dec 2008 05:47:22 -0800 (PST)
Message-ID: <416c461f0812040540q569321f6scf5f4716b6abcaee@mail.gmail.com>
Date: Fri, 5 Dec 2008 00:40:28 +1100
From: "Niv Sardi" <xaiki@cxhome.ath.cx>
Subject: Re: [patch 01/22] fix compile on 32 bit systems
In-Reply-To: <20081204131124.GA7276@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160649.658660000@bombadil.infradead.org>
	<87vdu07nvp.fsf@cxhome.ath.cx> <20081204123432.GC7085@infradead.org>
	<416c461f0812040503g13083bdbl7a9b716f17d2adc0@mail.gmail.com>
	<20081204131124.GA7276@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Bissectable commits my dear christoph, bissectable commits =)
Mark told me I should make you happy and put lots of patches of yours
in if you put them in nice git trees for us =) just send to list.

On Fri, Dec 5, 2008 at 12:11 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Dec 05, 2008 at 12:03:15AM +1100, Niv Sardi wrote:
>> Oh well, lachland allready checked it in like that...
>
> Just put in my add FMODE_NOCMTIME patch in, it removes all that invis
> file operations crap :)  Seriously, it's already been reviewed on
> -fsdevel anyway.
>
>



-- 
Niv Sardi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

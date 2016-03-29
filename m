Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E2C3C7CA0
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 01:46:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 467FBAC002
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 23:46:34 -0700 (PDT)
Received: from mail-io0-f194.google.com (mail-io0-f194.google.com
	[209.85.223.194]) by cuda.sgi.com with ESMTP id
	52DPCg3eyNdRDmIB (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2016 23:46:32 -0700 (PDT)
Received: by mail-io0-f194.google.com with SMTP id g185so1361662ioa.0
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2016 23:46:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160328224710.GC5822@birch.djwong.org>
References: <CAMuHMdXx80zs5VoA_aYc_wMn37O=fa6oXk-ovteHq0hGQYUUzg@mail.gmail.com>
	<CAMuHMdW3dfhZVT0e4tiqsbEPjYYA_hGUXQer1bQDeF2Gbs4WJg@mail.gmail.com>
	<20160328215923.GG11812@dastard>
	<20160328224710.GC5822@birch.djwong.org>
Date: Tue, 29 Mar 2016 08:46:32 +0200
Message-ID: <CAMuHMdURaU0s4H9AzX+8moGWseBRaqfx8svksWzOQyK9TS7LMA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v4.6-rc1
From: Geert Uytterhoeven <geert@linux-m68k.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Rich Felker <dalias@libc.org>, Cris <linux-cris-kernel@axis.com>, Linux-sh list <linux-sh@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Mar 29, 2016 at 12:47 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> (No idea if it fixes fixes cris, but it passes the six arches that I can
> actually test on (x86/power/arm)).  The downside is that it does nothing about

https://www.kernel.org/pub/tools/crosstool/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

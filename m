Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0OKk8ur114961 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 14:46:09 -0600
Received: from mail-out.m-online.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A18DD88CDD6
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 12:48:29 -0800 (PST)
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.10]) by
	cuda.sgi.com with ESMTP id kYdlATRwdCUqihrN for
	<xfs@oss.sgi.com>; Mon, 24 Jan 2011 12:48:29 -0800 (PST)
From: Wolfgang Denk <wd@denx.de>
Subject: Re: Optimize RAID0 for max IOPS?
MIME-Version: 1.0
In-reply-to: <alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
References: <20110118210112.D13A236C@gemini.denx.de>
	<4D361F26.3060507@stud.tu-ilmenau.de>
	<20110119192104.1FA92D30267@gemini.denx.de>
	<AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
	<alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
Date: Mon, 24 Jan 2011 21:48:27 +0100
Message-Id: <20110124204827.B707FB187@gemini.denx.de>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com

Dear Justin Piszcz,

In message <alpine.DEB.2.00.1101241024230.14640@p34.internal.lan> you wrote:
>
> > So, you may need to benchmark fs part.
> 
> Some info on XFS benchmark with delaylog here:
> http://comments.gmane.org/gmane.comp.file-systems.xfs.general/34379

Thanks a lot for the pointer. I will try this out.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Madness takes its toll. Please have exact change.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

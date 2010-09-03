Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o83GW8WO259114 for <xfs@oss.sgi.com>; Fri, 3 Sep 2010 11:32:09 -0500
Received: from smtpo08.poczta.onet.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D62CB49C25
	for <xfs@oss.sgi.com>; Fri,  3 Sep 2010 09:32:42 -0700 (PDT)
Received: from smtpo08.poczta.onet.pl (smtpo08.poczta.onet.pl
	[213.180.142.139]) by cuda.sgi.com with ESMTP id
	QhZIxvCgrLsTvDOW for <xfs@oss.sgi.com>;
	Fri, 03 Sep 2010 09:32:42 -0700 (PDT)
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:27149 "EHLO
	orion.wszechswiat.org" rhost-flags-OK-OK-OK-FAIL) by ps2.m5r2.onet
	with ESMTPSA id S134218652Ab0ICQclmT97p (ORCPT
	<rfc822;xfs@oss.sgi.com>); Fri, 3 Sep 2010 18:32:41 +0200
Message-ID: <4C812320.7080303@op.pl>
Date: Fri, 03 Sep 2010 18:32:32 +0200
From: Bogdan <bogdandr@op.pl>
MIME-Version: 1.0
Subject: Re: xfsprogs: minimum version with these commands
References: <4C7A2654.3080106@op.pl> <4C7B0EF6.5030505@sandeen.net>
	<4C7BDDB1.6030209@op.pl> <4C7BDFE1.10804@sandeen.net>
	<4C7E7852.9090905@op.pl> <4C7E799F.8050801@sandeen.net>
In-Reply-To: <4C7E799F.8050801@sandeen.net>
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
Cc: xfs@oss.sgi.com

On 01.09.2010 18:04, Eric Sandeen wrote:
> Bogdan wrote:
> 
>>> I think the fastest route, since nothing you asked for is particularly
>>> "new" would be to just grab a sufficiently old version and double check
>>> that the commands are there.  Easier than chasing through the repository,
>>> I think.
>>
>>  Surely. But where do I get such old versions?
>>
> 
> CVS should have older but that can be hard to work with
> 
> If it's ok with you to use old fedora src.rpms, try:
> 
> http://kojipkgs.fedoraproject.org/packages/xfsprogs
> 
> which goes back to 2.8.11 in Apr. 2007.
> 
> Ah I just found:
> 
> ftp://oss.sgi.com/projects/xfs/previous/cmd_tars/xfsprogs-2.7.11.src.tar.gz
> 
> as well.
> 
> I really think any serious user of xfs will not be using
> tools which are more than 5 years old, so if these versions satisfy
> your requirements, I wouldn't worry too much about whether older
> versions do as well...

 OK, thank you for your time and help.

-- 
Pozdrawiam/Regards - Bogdan                     (GNU/Linux & FreeDOS)
Kurs asemblera x86 (DOS, GNU/Linux):http://rudy.mif.pg.gda.pl/~bogdro
Grupy dyskusyjne o asm:  pl.comp.lang.asm alt.pl.asm alt.pl.asm.win32
www.Xiph.org   www.TorProject.org   Soft (EN): miniurl.pl/bogdro-soft

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

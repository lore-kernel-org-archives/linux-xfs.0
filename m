Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o81Fx80a146580 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 10:59:08 -0500
Received: from smtpo06.poczta.onet.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AAE8B15DBBD2
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 09:10:19 -0700 (PDT)
Received: from smtpo06.poczta.onet.pl (smtpo06.poczta.onet.pl
	[213.180.142.137]) by cuda.sgi.com with ESMTP id
	FPkUgJZ4pyLLQEH3 for <xfs@oss.sgi.com>;
	Wed, 01 Sep 2010 09:10:19 -0700 (PDT)
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:43698 "EHLO
	orion.wszechswiat.org" rhost-flags-OK-OK-OK-FAIL) by ps2.m5r2.onet
	with ESMTPSA id S134225250Ab0IAP7lg9J0o (ORCPT
	<rfc822;xfs@oss.sgi.com>); Wed, 1 Sep 2010 17:59:41 +0200
Message-ID: <4C7E7852.9090905@op.pl>
Date: Wed, 01 Sep 2010 17:59:14 +0200
From: Bogdan <bogdandr@op.pl>
MIME-Version: 1.0
Subject: Re: xfsprogs: minimum version with these commands
References: <4C7A2654.3080106@op.pl> <4C7B0EF6.5030505@sandeen.net>
	<4C7BDDB1.6030209@op.pl> <4C7BDFE1.10804@sandeen.net>
In-Reply-To: <4C7BDFE1.10804@sandeen.net>
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

On 30.08.2010 18:44, Eric Sandeen wrote:
> Bogdan wrote:
>>  Is everything really there? How do I get these?
> 
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsprogs.git
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/cmds/xfsdump.git
> 
> http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/
> 
> Most everything should be there.

 Starting from version 3, as I can see. I couldn't go further in the past.

>>> Most of the things you ask about are SO OLD it will take some digging
>>> through renames and moves.
>>
>>  I thought so. I'm surprised such things as added commands aren't in
>> the ChangeLog, unless they were present from the first version.
>>
>>> Do you really need to know if "xfs_check" was added in 1994, or 1995, for
>>> example? :)
>>
>>  No. I need to know what was the first version of the xfsprogs package
>> that contained this program. The version number, not the year.
> 
> well, equivalently, do you care if it was version 1.0.0 or 1.0.1, from the
> 1990's era.
> 
> For everything you asked about, I think they've all been there since
> inception.

 That would be good.

> I think picking a version from maybe 5 years ago and checking that the
> commands are all there would suffice; it would be -very- unlikely that
> anything older is still in use.

 Hopefully. I got some versions like 2.0.3 and 2.7.11. Where do I get
older?

>>> This strikes me as a bit of an odd question; what is your motivation here?
>>
>>  I'm writing a program that executes xfs_db and other processes,
>> passes commands to them and reads replies. Now I want to know what the
>> minimum required version is to be sure that these commands are
>> accepted. I know this might seem strange, but I'd like to know this in
>> more detail, so I can say "requires xfsprogs version X.Y.Z or newer"
>> instead of "requires xfsprogs" (which would imply that all versions
>> work, and this might not be the case). If it would be "1.0.0", great.
>> But I wanted to be sure.
> 
> Ok, understood.
> 
> I think the fastest route, since nothing you asked for is particularly
> "new" would be to just grab a sufficiently old version and double check
> that the commands are there.  Easier than chasing through the repository,
> I think.

 Surely. But where do I get such old versions?

-- 
Pozdrawiam/Regards - Bogdan                     (GNU/Linux & FreeDOS)
Kurs asemblera x86 (DOS, GNU/Linux):http://rudy.mif.pg.gda.pl/~bogdro
Grupy dyskusyjne o asm:  pl.comp.lang.asm alt.pl.asm alt.pl.asm.win32
www.Xiph.org   www.TorProject.org   Soft (EN): miniurl.pl/bogdro-soft

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

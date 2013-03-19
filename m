Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AA77D7F67
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 03:24:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 84EEC304043
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 01:24:55 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id xFRv89nQdsSUqNle for
	<xfs@oss.sgi.com>; Tue, 19 Mar 2013 01:24:53 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Xfs_repair and journalling
Date: Tue, 19 Mar 2013 09:24:28 +0100
References: <CAEUQceh-Xcabr0KErxF6EAdafDDP1PY_AeHwgYB82QeUdyGp-g@mail.gmail.com>
	<5147E360.10605@sandeen.net> <5148037B.5010706@hardwarefreak.com>
	(sfid-20130319_091205_759083_BA6F1AD2)
In-Reply-To: <5148037B.5010706@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201303190924.29362.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan@hardwarefreak.com
Cc: Eric Sandeen <sandeen@sandeen.net>, Subranshu Patel <spatel.ml@gmail.com>, xfs@oss.sgi.com

Am Dienstag, 19. M=E4rz 2013 schrieb Stan Hoeppner:
> Martin, I didn't state that ext4 cannot perform journal recovery, which
> you previously misunderstood.  As mentioned above I stated it made a
> call to e2fsck to perform the task.  And, again, apparently this is not
> the case.  If you want to excoriate me for getting this wrong, that's
> fine.  But don't do it in a way that suggests it was intentional, or
> that I made no effort to verify the information before I stated it.  I
> spent at least 30 minutes Googling trying to track down documents
> explaining the ext4 journal recovery code in the kernel.  I simply
> didn't find any.  The only thing I found were descriptions of e2fsck
> based journal recovery.

Stan, you are still a XFS expert, you are still a hardware expert, and I =

love reading your posts at debian-user, I sometimes even search for those, =

you still know a lot and heck you are still Stan and as such without any =

achievement or knowledge at all a precious being.

Just like anyone else on this list (and elsewhere) is a precious being just =

as they are.

So whats so difficult with admitting that what you wrote about Ext4 and =

journal replay as at least misleading?

Heck, even I was confused at first. Cause the manpage of fsck.ext4 IMHO is =

not really clear about that topic to say the least. I tested it out for a =

reason.

I am concerned about the tendency I perceive in open source, heck general =

computer communities to bind own value to being right on a topic. There is =

no, absolutely no connection at all. You and everyone else is valuable and =

precious without any prerequisite at all.

I also take some to learn out of this myself: Cause I was obsessed with =

being right myself and bound my value to it as well. I have overdone my =

previous mails. Sorry for that.

Thanks,
-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

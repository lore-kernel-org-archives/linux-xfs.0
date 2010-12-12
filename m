Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBC3KrYY063574 for <xfs@oss.sgi.com>; Sat, 11 Dec 2010 21:20:54 -0600
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69EF8143DBC9
	for <xfs@oss.sgi.com>; Sat, 11 Dec 2010 19:22:43 -0800 (PST)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	xeiM7Iyavcd71HM2 for <xfs@oss.sgi.com>;
	Sat, 11 Dec 2010 19:22:43 -0800 (PST)
Received: from mail-iw0-f178.google.com (mail-iw0-f178.google.com
	[209.85.214.178]) (authenticated bits=0)
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with
	ESMTP id oBC3McGT008080
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=FAIL)
	for <xfs@oss.sgi.com>; Sat, 11 Dec 2010 19:22:38 -0800
Received: by iwn1 with SMTP id 1so7722798iwn.37
	for <xfs@oss.sgi.com>; Sat, 11 Dec 2010 19:22:36 -0800 (PST)
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 11 Dec 2010 19:22:16 -0800
Message-ID: <AANLkTim4Y+gG+tRdAivZMJ93e2hESvJed5vjkuzv63Rh@mail.gmail.com>
Subject: Re: [GIT PULL] Please pull xyzzy fixes
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
To: Trond Myklebust <Trond.Myklebust@netapp.com>, Len Brown <lenb@kernel.org>, Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@opensource.wolfsonmicro.com>, Alex Elder <aelder@sgi.com>, Tejun Heo <tj@kernel.org>, Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>, Sage Weil <sage@newdream.net>, Takashi Iwai <tiwai@suse.de>, Borislav Petkov <bp@amd64.org>, Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, ceph-devel@vger.kernel.org, linux-pm@lists.linux-foundation.org

On Fri, Dec 10, 2010 at 10:05 AM, Trond Myklebust
<Trond.Myklebust@netapp.com> wrote:
> Resending pull request after appending Chuck's fix for the nfs_umount() panic.

[ .. and other people have other similar pull requests - acpi, ceph,
cifs, xfs etc ]

Right now I'm traveling without access to my laptop to actually do
pulls. That was unintentional, but my laptop got co-opted for more
important stuff (child needed it for school an my other laptop has a
broken harddisk), so I've just been reading email with my cellphone.
That allows me to keep up-to-date and mark the stuff that I'm
scheduling for pulling, but I end up not replying a lot because typing
is so painful and it does that silly html email thing.

Anyway, this is just a reply to say that I've not lost your emails,
I'm just effectively partly offline until Monday. I just stole Dirk's
laptop just to write a reply-to-all (or at least a "reply-to-most").

                                         Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

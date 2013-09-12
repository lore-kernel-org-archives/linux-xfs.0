Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7B3C87F52
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 16:38:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A8C5304032
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 14:38:47 -0700 (PDT)
Received: from mail-wg0-f53.google.com (mail-wg0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id cYsxAmoXvEanwstI
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 14:38:45 -0700 (PDT)
Received: by mail-wg0-f53.google.com with SMTP id x12so382486wgg.8
	for <linux-xfs@oss.sgi.com>; Thu, 12 Sep 2013 14:38:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52322F7A.8060405@sandeen.net>
References: <52322F7A.8060405@sandeen.net>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Thu, 12 Sep 2013 17:38:04 -0400
Message-ID: <CAGpXXZLB_Eim=7yqCx9jhSomKCpo_hFhc=5=B-O--_=sRBtC0w@mail.gmail.com>
Subject: Re: Time for an xfsprogs "alpha1" release?
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@oss.sgi.com" <linux-xfs@oss.sgi.com>

On Thu, Sep 12, 2013 at 5:17 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> With all of the changes for CRC filesystems in xfsprogs git now, I'm wondering if it'd be a good idea to do a "3.2.0-alpha1" sort of release.
>
> I know it's not yet feature complete, but I think there would be value in getting a version-stamped tarball out there for testing - it could filter to rawhide-ish distros, and get a bit more airtime while the remaining bits get worked out.
>
> We'd probably want a nice readme about what's new and what's not yet done, caveats, etc, but I think it'd be worth getting it out there into the hands of willing testers, w/o requiring them to do a build from git.
>
> Thoughts?
>
> Thanks,
> -Eric

If it's relevant, openSUSE's factory release is currently in feature
freeze for bleeding edge stuff, but it should open back up in a week
or two.  (After they branch off the next stable release.)

If you don't know factory => openSUSE => SUSE (SLES)

much like rawhide => fedora => redhat

Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

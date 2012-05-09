Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q497sB6i081177 for <xfs@oss.sgi.com>; Wed, 9 May 2012 02:54:11 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id Wc1fTF56mbKiXYaF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 May 2012 00:54:09 -0700 (PDT)
Received: by dadg9 with SMTP id g9so1453407dad.26
	for <xfs@oss.sgi.com>; Wed, 09 May 2012 00:54:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120507171908.GA16881@sgi.com>
References: <CADLDEKs01GnxgYh2UTt1waVDUXHbB_RcBcUTBr5REFg5aD5jHA@mail.gmail.com>
	<20120425223845.GX9541@dastard>
	<CADLDEKvYkpUnMrqdMyqCmsYrZcUtiJ6ZRhrRu_ERTjn=r7M3Pg@mail.gmail.com>
	<20120426224412.GA9541@dastard>
	<CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507171908.GA16881@sgi.com>
Date: Wed, 9 May 2012 09:54:08 +0200
Message-ID: <CADLDEKvgT_FcGhJKoPaQv0mh_Jqdaqu8SYatc9xxU7vOY217YQ@mail.gmail.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
From: Juerg Haefliger <juergh@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

Ben,

> Hey Juerg,
>
> On Sat, May 05, 2012 at 09:44:35AM +0200, Juerg Haefliger wrote:
>> Did anybody have a chance to look at the data?
>
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/979498
>
> Here you indicate that you have created a reproducer. =A0Can you post it =
to the list?

Canonical attached them to the bug report that they filed yesterday:
http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D922

...Juerg


> Thanks,
> =A0 =A0 =A0 =A0Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

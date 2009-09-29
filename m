Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8TCpfOn204834 for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 07:51:41 -0500
Received: from mail-pz0-f173.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 325CA1D731C9
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 05:53:01 -0700 (PDT)
Received: from mail-pz0-f173.google.com (mail-pz0-f173.google.com
	[209.85.222.173]) by cuda.sgi.com with ESMTP id
	O8cyJ34y3SLNIm4w for <xfs@oss.sgi.com>;
	Tue, 29 Sep 2009 05:53:01 -0700 (PDT)
Received: by pzk3 with SMTP id 3so1440327pzk.20
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2009 05:53:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <E87DB458899A9040ACD4D627073D9EF606028EAC@VFOHMLAO11.Enterprise.afmc.ds.af.mil>
References: <E87DB458899A9040ACD4D627073D9EF606028EAC@VFOHMLAO11.Enterprise.afmc.ds.af.mil>
Date: Tue, 29 Sep 2009 18:23:00 +0530
Message-ID: <921ca19c0909290553x39e45366s1133173c033b6d34@mail.gmail.com>
Subject: Re: XFS Question
From: Sujit K M <sjt.kar@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Shue, David CTR USAF AFMC AFRL/RITB" <David.Shue.ctr@rl.af.mil>
Cc: xfs@oss.sgi.com

Hi,

I donot think there will be any guarantee to the system unless base
kernel is built to the RHEL 5.3 Distribution.
I have an ubuntu 8.10 but when I had tried upgrading to ubuntu 9.04 I
had Issues which I had to remain at 8.10.
I think you will have to use an vanilla for the kernel on 5.3 and then
upgrade.  Sorry will not be able to give
you more details regarding the RedHat Distribution. Not been using
RHEL for past 3 Years. Found Ubuntu much
Cheaper.

Thanks,
Sujit

On Tue, Sep 29, 2009 at 5:51 PM, Shue, David CTR USAF AFMC AFRL/RITB
<David.Shue.ctr@rl.af.mil> wrote:
> Hello,
>
>
>
> I originally installed XFS on my RHEL 5.1 system.=A0 This system is on a
> closed network. I would like to update the system to the latest RHEL
> release(5.4).=A0 I=92m curious about what will happen to my XFS file syst=
em(or
> communication to it).=A0 When I originally set it up, I used three(3) RPM=
=92s:
>
>
>
> Kernel-module-xfs-#####
>
> Xfsprogs-####
>
> Xfsprogs-devel-####
>
>
>
> My question is, I will perform the system update, but what will happen to=
 my
> XFS system?=A0 Do I simply locate the above three RPM=92s for the latest =
kernel
> I am installing and be good to go?
>
>
>
> I am continuing to read the helpful sites where I obtained this email.
>
>
>
> Thank you in advance,
>
>
>
> Dave
>
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>
>



-- =

-- Sujit K M

blog(http://kmsujit.blogspot.com/)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

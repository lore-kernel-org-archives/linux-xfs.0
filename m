Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 260EC7F37
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 23:44:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D7A98F804B
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 21:44:58 -0700 (PDT)
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com
	[209.85.218.49]) by cuda.sgi.com with ESMTP id i3kFEAs1RkKvaSsB
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 23 Aug 2015 21:44:53 -0700 (PDT)
Received: by oiey141 with SMTP id y141so73153671oie.1
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 21:44:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJtCNH0tgtCw0F7322b_qvbM9-uGGSsLLiPQj6jk1yyvWDQMYg@mail.gmail.com>
References: <CAJtCNH0tgtCw0F7322b_qvbM9-uGGSsLLiPQj6jk1yyvWDQMYg@mail.gmail.com>
Date: Mon, 24 Aug 2015 10:14:52 +0530
Message-ID: <CAJtCNH1EyP6d+rGeJRzaAx7Mh+s89hEudDbfbwofYK_tJD6x4A@mail.gmail.com>
Subject: Re: How to determine the reserved blocks in xfs filesystem ?
From: Mukul Malhotra <smilemukul2005@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7490691284891282589=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7490691284891282589==
Content-Type: multipart/alternative; boundary=001a113cdbbe419e57051e074777

--001a113cdbbe419e57051e074777
Content-Type: text/plain; charset=UTF-8

Hi,

I have below queries on XFS log device as,

1. After creating a XFS filesystem with an external log device (journal),
is there a way to mount the filesystem if I lose the external log device or
a way to recover files?

2. Is there a way to convert an existing XFS filesystem which has internal
log to external log and vice versa.

Need help on above queries.


Thank You
Mukul Malhotra

--001a113cdbbe419e57051e074777
Content-Type: text/html; charset=UTF-8

<div dir="ltr"><div class="gmail_default" style="font-size:small">Hi,<br><br></div><div class="gmail_default" style="font-size:small">I have below queries on XFS log device as,<br><br>1. After creating a XFS filesystem with an external log device
    (journal), is there a way to mount the filesystem if I lose the
    external log device or a way to recover files?<br>
    <br>
    2. Is there a way to convert an existing XFS filesystem which has
    internal log to external log and vice versa. <br>
    <br>
    Need help on above queries.<br><br></div><div class="gmail_extra"><br clear="all"><div><div class="gmail_signature"><div dir="ltr">Thank You<br>Mukul Malhotra<br></div></div></div></div></div>

--001a113cdbbe419e57051e074777--


--===============7490691284891282589==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7490691284891282589==--

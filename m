Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DBA8E7F5D
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 20:28:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5A8E6AC002
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 18:28:29 -0800 (PST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com
	[74.125.82.44]) by cuda.sgi.com with ESMTP id iUNvDLqOIp89i74g
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Nov 2015 18:28:27 -0800 (PST)
Received: by wmww144 with SMTP id w144so182600782wmw.1
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 18:28:26 -0800 (PST)
Received: from Minas-Anor.Valinor (248.Red-81-36-103.dynamicIP.rima-tde.net.
	[81.36.103.248]) by smtp.googlemail.com with ESMTPSA id
	69sm1207690wmw.0.2015.11.11.18.28.25 for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Wed, 11 Nov 2015 18:28:25 -0800 (PST)
Subject: Re: xfsprogs install
References: <CAFf1yNFYh3C9NR8OadL=wXALT3mj58LTVvnE3fypOBXOP_JzoQ@mail.gmail.com>
	<20151111125021.GA28745@redhat.com>
	<CAFf1yNFwY5uANDbTQhQsmdZj=FzOduUDcGGTNG-EnK0P0a+=7w@mail.gmail.com>
From: "Carlos E. R" <carlos.e.r@opensuse.org>
Message-ID: <5643F948.2030703@opensuse.org>
Date: Thu, 12 Nov 2015 03:28:24 +0100
MIME-Version: 1.0
In-Reply-To: <CAFf1yNFwY5uANDbTQhQsmdZj=FzOduUDcGGTNG-EnK0P0a+=7w@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 11/12/2015 03:21 AM, rui li wrote:
> thanks !
> when i run mkfs.xfs -f /dev/sda2p1 ,the error is no that file or directory
> acturally /dev/sda2p1  existed
> could you give me some help?
> thank you very much

Why don't you try:

LANG=POSIX mkfs.xfs -f /dev/sda2p1

and then post what you get here (it will be in English). Use copy paste, 
don't type nor translate.

-- 
Cheers/Saludos

          Carlos E. R. (openSUSE Leap 42.1, test at Minas-Anor)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

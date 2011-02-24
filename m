Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1OAN9oQ129101 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 04:23:09 -0600
Received: from mail-gw0-f46.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5E5D149B32E
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 02:25:54 -0800 (PST)
Received: from mail-gw0-f46.google.com (mail-gw0-f46.google.com
	[74.125.83.46]) by cuda.sgi.com with ESMTP id IheVJyeM5yg3XSix
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 02:25:54 -0800 (PST)
Received: by gwj20 with SMTP id 20so269316gwj.5
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 02:25:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1102231041120.15181@p34.internal.lan>
References: <AANLkTinWByYooMnPL7BryPowDexBeiHJdh3aVh+fdm-a@mail.gmail.com>
	<20110223154651.54f0a8dc@harpe.intellique.com>
	<AANLkTinsfwr5E7KkffwWOweWJLCmaLnLdtYA4g_m--b0@mail.gmail.com>
	<alpine.DEB.2.02.1102231022470.15181@p34.internal.lan>
	<20110223163737.3c2fcd0b@harpe.intellique.com>
	<alpine.DEB.2.02.1102231041120.15181@p34.internal.lan>
Date: Thu, 24 Feb 2011 11:25:53 +0100
Message-ID: <AANLkTimqtV63pkRj6rUcf6o9E0KV8KJo3OX4XNMtkc+Z@mail.gmail.com>
Subject: Re: XFS corruption on 3ware RAID6-volume
From: Erik Gulliksson <erik@gulliksson.org>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Hi Justin,

On Wed, Feb 23, 2011 at 4:42 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wr=
ote:
>
>
> On Wed, 23 Feb 2011, Emmanuel Florac wrote:
>
>> Le Wed, 23 Feb 2011 10:29:15 -0500 (EST)
>> Justin Piszcz <jpiszcz@lucidpixels.com> =E9crivait:
>>
>>>> /c0 Firmware Version =3D FE9X 4.10.00.007
>>>
>>> The latest is:
>>>
>>> 9.5.1-9650-Upgrade.zip
>>> 9.5.2-9650-Upgrade.zip
>>> 9.5.3-9650-Upgrade.zip
>>> 9650SE_9690SA_firmware_beta_fw4.10.00.016.zip
>>> 9650SE_9690SA_firmware_beta_fw_4.10.00.019.zip <- latest
>>
>> Hum well, this is beta, I'd rather stick to released firmware :) His
>> firmware is actually the latest stable version for the 9650.
>
> Yes, but it specifically addresses issue with resets:

I think I'll stick with changing the disks with enterprise-versions.
There might be other reasons why 3ware/LSI still has those firmware
fixes in beta.

Best regards
Erik Gulliksson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

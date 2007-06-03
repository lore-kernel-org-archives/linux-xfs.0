Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Jun 2007 00:23:51 -0700 (PDT)
Received: from pd3mo2so.prod.shaw.ca (shawidc-mo1.cg.shawcable.net [24.71.223.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l537NhWt020808
	for <xfs@oss.sgi.com>; Sun, 3 Jun 2007 00:23:44 -0700
Received: from pd2mr4so.prod.shaw.ca
 (pd2mr4so-qfe3.prod.shaw.ca [10.0.141.107]) by l-daemon
 (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with ESMTP id <0JJ10086OR3JP670@l-daemon> for xfs@oss.sgi.com; Sun,
 03 Jun 2007 00:23:43 -0600 (MDT)
Received: from pn2ml3so.prod.shaw.ca ([10.0.121.147])
 by pd2mr4so.prod.shaw.ca (Sun Java System Messaging Server 6.2-7.05 (built Sep
 5 2006)) with ESMTP id <0JJ100A65R3J1M20@pd2mr4so.prod.shaw.ca> for
 xfs@oss.sgi.com; Sun, 03 Jun 2007 00:23:43 -0600 (MDT)
Received: from [192.168.1.113] ([70.64.1.86])
 by l-daemon (Sun ONE Messaging Server 6.0 HotFix 1.01 (built Mar 15 2004))
 with ESMTP id <0JJ100DXZR3IE3N3@l-daemon> for xfs@oss.sgi.com; Sun,
 03 Jun 2007 00:23:42 -0600 (MDT)
Date: Sun, 03 Jun 2007 00:23:48 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Kernel 2.6.22-rc3 safe to migrate to?
In-reply-to: <fa.vxJKq726YMWJY2i/waKQsNec3aU@ifi.uio.no>
Message-id: <46625E74.8070800@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.eE9c0s9eXX/aO2N8hiu3e2Yehz8@ifi.uio.no>
 <fa.hq4JzIoUe01l8ywIZPkqjocRBmc@ifi.uio.no>
 <fa.3aN+T/xQVA3sf9DdMPLOfUVmYA0@ifi.uio.no>
 <fa.mJ71j4nyi6ALIkQjLcpIJtTbVVI@ifi.uio.no>
 <fa.vxJKq726YMWJY2i/waKQsNec3aU@ifi.uio.no>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Christian Kujau <lists@nerdbynature.de>, Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Justin Piszcz wrote:
> Sent this in another e-mail to LKML, it breaks support for my UPS:
> 
>  From jpiszcz@lucidpixels.com Sat Jun  2 18:43:52 2007
> Date: Sat, 2 Jun 2007 18:43:52 -0400 (EDT)
> From: Justin Piszcz <jpiszcz@lucidpixels.com>
> To: linux-kernel@vger.kernel.org
> Subject: Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor 
> (error sending control message: Operation not permitted)
> 
> I use nut-2.0.4-4 with a UPS attached via USB and from 2.6.21.3 -> 
> 2.6.22-rc3 it
> stops working, see below.  My .config is attached.
> 

I also have seen this on -rc2-mm1, my APC UPS status was not showing up. 
  I haven't investigated in any more detail.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

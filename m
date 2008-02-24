Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 04:17:19 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1OCHDNv015208
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 04:17:15 -0800
Received: from stine.vestdata.no (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59EE760F9FC
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 04:17:36 -0800 (PST)
Received: from stine.vestdata.no (stine.vestdata.no [217.149.127.10]) by cuda.sgi.com with ESMTP id xIDS7kMhmNITy8KE for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 04:17:36 -0800 (PST)
Date: Sun, 24 Feb 2008 13:17:23 +0100
From: Ragnar =?iso-8859-15?Q?Kj=F8rstad?= <xfs@ragnark.vestdata.no>
Subject: Re: xfs I/O error
Message-ID: <20080224121722.GY29277@vestdata.no>
References: <2db2c6b80802231346r78d59381j49927e15f40e7ef8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2db2c6b80802231346r78d59381j49927e15f40e7ef8@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rekrutacja119 <rekrutacja119@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Feb 23, 2008 at 10:46:52PM +0100, Rekrutacja119 wrote:
> the easiest solution would be to just ignore errors, and if not, then to
> somehow force xfs to mark them as bad sectors

If you really wanted to you could probably use dm to map your bad
sectors to another device.

-- 
Ragnar Kjørstad
Software Engineer
Platform Computing

Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 20:10:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6P3AV9L032748
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 20:10:31 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 356A6E9DE2F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 20:11:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 5CMEIGDPCd4Wz7Oy for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 20:11:42 -0700 (PDT)
Message-ID: <48894466.4020507@sandeen.net>
Date: Thu, 24 Jul 2008 22:11:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] - remove mounpoint UUID code
References: <47D20F78.7000103@sandeen.net> <ncc7ibavh1s.fsf@itchy.melbourne.sgi.com>
In-Reply-To: <ncc7ibavh1s.fsf@itchy.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Niv Sardi wrote:
> ACK, removing it, it should be trivial to put back in if we ever need it.

Ok, hch had some comments and this needs a careful eye towards any
affected disk structures so probably should not go in immediately as-is.

-Eric

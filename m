Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Mar 2007 18:09:43 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2629a6p026087
	for <xfs@oss.sgi.com>; Mon, 5 Mar 2007 18:09:37 -0800
Subject: Re: Spanish and Galician translation
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <45EC7F67.3050308@mundo-r.com>
References: <45EC7F67.3050308@mundo-r.com>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 23:06:24 +1100
Message-Id: <1173182784.5051.7.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Antonio Trueba <atrueba@mundo-r.com>
Cc: xfs@oss.sgi.com

On Mon, 2007-03-05 at 21:36 +0100, Antonio Trueba wrote:
> Hello,
> 
> I'd like to know if someone is already translating XFS to Spanish (es) 
> or Galician (gl). If not, I'd like to do both myself.

Go for it, noone else if working on those AFAIK.  You should probably
rebuild the translation database ("cd xfsprogs/po && make xfsprogs.pot"
IIRC) first, its probably not been updated in awhile, and there's new
strings in xfs_repair at least.

Let me know if theres any issues getting it working - I know a little
bit about the build system in this area, so can help.

cheers.

-- 
Nathan

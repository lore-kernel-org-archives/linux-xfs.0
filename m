Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 62EC87F4E
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 06:32:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E73B8F8049
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 04:32:00 -0700 (PDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
	[209.85.212.178]) by cuda.sgi.com with ESMTP id
	mxsDdCoEDF3OBHRz (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Sep 2015 04:31:54 -0700 (PDT)
Received: by wicfx3 with SMTP id fx3so19532140wic.1
	for <xfs@oss.sgi.com>; Thu, 17 Sep 2015 04:31:53 -0700 (PDT)
Subject: Re: XFS FAQ - out of date?
References: <55FA0B1D.8000905@troja.ch>
	<CA+o=1OUpgK6w2W9Y8JHeN7ByopEuzEx1u87FhBPTcmZRSA0Bdg@mail.gmail.com>
From: Viktor Trojanovic <viktor@troja.ch>
Message-ID: <55FAA4A5.7000701@troja.ch>
Date: Thu, 17 Sep 2015 13:31:49 +0200
MIME-Version: 1.0
In-Reply-To: <CA+o=1OUpgK6w2W9Y8JHeN7ByopEuzEx1u87FhBPTcmZRSA0Bdg@mail.gmail.com>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On 17.09.2015 06:06, Fanael Linithien wrote:
> 2015-09-17 2:36 GMT+02:00 Viktor Trojanovic <viktor@troja.ch>:
>> I later found (very few) sources that confirmed that Grub is not compatible
>> with the current XFS level 5, that SuSE created a patch for the problem but
>> it wasn't adopted upstream.
> It is merged upstream[1], but last GRUB release was 2.02 beta 2, which
> is almost two years old. If you have no qualms about using grub-git
> from AUR, there will be no problems with XFS, even with v5 superblock.
>
> [1] http://git.savannah.gnu.org/cgit/grub.git/commit/grub-core/fs/xfs.c?id=b6e80c7778b708c1632d957d00507aad60d9e255

Great, I'll try that. Thanks for replying.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

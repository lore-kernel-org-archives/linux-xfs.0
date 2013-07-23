Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 870BB7F3F
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 16:27:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6FA968F8040
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 14:27:48 -0700 (PDT)
Received: from Ishtar.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id yCjfAHvljFX2owqB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Jul 2013 14:27:46 -0700 (PDT)
Received: from [192.168.4.12] (Athenae [192.168.4.12])
	by Ishtar.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id
	r6NLRYvl088756 for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 14:27:36 -0700
Message-ID: <51EEF543.5020305@tlinx.org>
Date: Tue, 23 Jul 2013 14:27:31 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: RFE: the manpage claims no limits on size of file extended attributes;
	has this now true?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Ok, lemme rephrase my questions...

The man page lists maximums for values at 64K, and names at 255
characters.  This implies these are the only limits one need worry about
-- i.e. there is no limit on the maximum number of 255 byte names nor is
there a limit on the sum of the values of attributes.   Is it something
like 2^60 bytes? or some such limit that no one will ever hit?   Could
I store alternate soundtracks for movies in attribute fields, or
alternate scenes for movies?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

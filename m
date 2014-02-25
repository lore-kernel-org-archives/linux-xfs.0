Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D95C57F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 11:04:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B2CB28F83B4
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 09:04:17 -0800 (PST)
Received: from internal-smtp4.wesleyan.edu (internal-smtp4.wesleyan.edu
	[129.133.6.200]) by cuda.sgi.com with ESMTP id 7oqCIeAHKnHvaH2i
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 09:04:15 -0800 (PST)
From: "C. Morgan Hamill" <chamill@wesleyan.edu>
In-reply-to: <530809A7.70900@hardwarefreak.com>
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <52E91923.4070706@sandeen.net> <52EB3B96.7000103@hardwarefreak.com>
	<1391202273-sup-9265@al.wesleyan.edu>
	<52ED61C9.8060504@hardwarefreak.com>
	<20140202212152.GP2212@dastard>
	<1391443675-sup-1730@al.wesleyan.edu>
	<20140203214128.GR13997@dastard>
	<52F09E36.8050606@hardwarefreak.com>
	<1392748390-sup-1943@al.wesleyan.edu>
	<5303E7AC.50903@hardwarefreak.com>
	<20140220183125.29149.64880@al.wesleyan.edu>
	<5306C90B.1000904@hardwarefreak.com>
	<20140221095742.0ca161b0@galadriel.home>
	<530809A7.70900@hardwarefreak.com>
Date: Tue, 25 Feb 2014 12:04:10 -0500
Message-Id: <1393347755-sup-205@al.wesleyan.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan <stan@hardwarefreak.com>
Cc: xfs <xfs@oss.sgi.com>

Excerpts from Stan Hoeppner's message of 2014-02-21 21:21:27 -0500:
> Now, it's possible he could do this entirely in the RAID firmware.
> However he has not stated which storage product he has, and thus I don't
> know its capabilities, whether it can create or seamlessly expand a
> concatenation.  Linux md can do all of this very easily and is deployed
> by many people in this exact scenario.

On this note, I'm using an Areca ARC-1882.  I've been looking for
documentation regarding concatenation with this, and having a bit of
trouble.

Do you happen to be familiar with the product?
--
Morgan Hamill

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

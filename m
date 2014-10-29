Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4882A7F37
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 23:28:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 192548F8033
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2014 21:28:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fYc1974HKGkjM21U for <xfs@oss.sgi.com>;
	Tue, 28 Oct 2014 21:28:10 -0700 (PDT)
Message-ID: <54506CD9.90403@sandeen.net>
Date: Tue, 28 Oct 2014 23:28:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>	<5450686F.9070307@sandeen.net>
	<CAGdb-8d5-GuB40ZgP6uM5aQMi+qqaeFd=xqzuxWhM+1AaoLSVw@mail.gmail.com>
In-Reply-To: <CAGdb-8d5-GuB40ZgP6uM5aQMi+qqaeFd=xqzuxWhM+1AaoLSVw@mail.gmail.com>
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
To: Tommy Wu <wu.tommy@gmail.com>
Cc: xfs <xfs@oss.sgi.com>

On 10/28/14 11:27 PM, Tommy Wu wrote:
> In "xfsdump not work in 3.17", after apply the 2 patches, xfsdump work (won't hang).
> But xfsrestore can't restore the dump correctly (like the case in this email).
> 
> Is other patch I miss?  I check the thread in Archive again, I don't see any patch about the xfsrestore issue.

Was the dump you are restoring created with those 2 patches in place?  Or was
it created with the stock/unpatched 3.17 kernel?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

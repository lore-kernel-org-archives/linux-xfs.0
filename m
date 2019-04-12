Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vs1-f54.google.com ([209.85.217.54]:43007 "EHLO
        mail-vs1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbfDLOat (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Apr 2019 10:30:49 -0400
Received: by mail-vs1-f54.google.com with SMTP id f15so5645088vsk.9
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2019 07:30:49 -0700 (PDT)
Subject: Re: About http://man7.org/linux/man-pages/man8/xfs_repair.8.html
References: <20190410150122.GA1019523@magnolia>
From: "Michael Kerrisk (man-opages)" <mtk.manpages@gmail.com>
Message-ID: <489d2955-93b5-f051-e0f8-e8fe83794a24@gmail.com>
Date: Fri, 12 Apr 2019 16:30:46 +0200
MIME-Version: 1.0
In-Reply-To: <20190410150122.GA1019523@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Manual Pages <man-pages@man7.org>
Cc: mtk.manpages@gmail.com, xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>

Hello Darrick

On 4/10/19 5:01 PM, Darrick J. Wong wrote:
> Hi,
> 
> I was browsing man7.org looking for manual pages and came across this:
> 
> http://man7.org/linux/man-pages/man8/xfs_repair.8.html
> 
> Hm, that's cool that it pulls in xfsprogs manpages now. :)
> 
> Unfortunately, I got to the bottom and saw:
> 
>     "Information about the project can be found at ⟨http://xfs.org/⟩. If
>     you have a bug report for this manual page, see
>     ⟨http://oss.sgi.com/bugzilla/buglist.cgi?product=XFS⟩.  This page was
>     obtained from the project's upstream Git repository
>     ⟨git://oss.sgi.com/xfs/cmds/xfsprogs⟩ on 2019-03-06.  (At that time,
>     the date of the most recent commit that was found in the repository
>     was 2019-02-22.)"
> 
> The last two URLs here are incorrect.  Linux XFS no longer uses any SGI
> servers, I think oss.sgi.com has been dead for 18 months, and xfs.org .
> In any case, bug reports should go to [1] and the upstream git repo is
> [2].  Could you please update whatever's generating man7.org?
> 
> Thanks,
> 
> --D
> 
> [1] mailto:linux-xfs@vger.kernel.org
> [2] https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/

Thanks for the report. I've updated the URLs for my scripts.
The fix will roll out to the site with the next refresh.

Thanks,

Michael
